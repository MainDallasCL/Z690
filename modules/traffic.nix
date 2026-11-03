# traffic-control.nix
{ config, lib, pkgs, ... }:

let
  cfg = config.services.trafficctl;

  ip = "${pkgs.iproute2}/bin/ip";
  tc = "${pkgs.iproute2}/bin/tc";

  ifb = cfg.ifbName;
  wan = cfg.wanInterface;

  # Shorthand: "{ 22, 53 }"
  nftSet = ports: "{ ${lib.concatStringsSep ", " ports} }";

  egressOpts = lib.concatStringsSep " " (
    [ "diffserv4" "dual-srchost" "nat" "wash" "ack-filter" ] ++ cfg.extraEgressOptions
  );

  ingressOpts = lib.concatStringsSep " " (
    [ "diffserv4" "dual-dsthost" "nat" "ingress" ] ++ cfg.extraIngressOptions
  );

  # Emits IPv4 + IPv6 DSCP-marking rules for one protocol/port list, both directions.
  markRules = { proto, ports, dscp }: lib.optionalString (ports != [ ]) ''
    oifname "${wan}" meta nfproto ipv4 meta l4proto ${proto} ${proto} sport ${nftSet ports} ip dscp set ${dscp}
    oifname "${wan}" meta nfproto ipv4 meta l4proto ${proto} ${proto} dport ${nftSet ports} ip dscp set ${dscp}
    oifname "${wan}" meta nfproto ipv6 meta l4proto ${proto} ${proto} sport ${nftSet ports} ip6 dscp set ${dscp}
    oifname "${wan}" meta nfproto ipv6 meta l4proto ${proto} ${proto} dport ${nftSet ports} ip6 dscp set ${dscp}
  '';

  startScript = pkgs.writeShellScript "trafficctl-start" ''
    set -eu
    W="${wan}"
    I="${ifb}"

    # IFB device used to shape ingress
    ${ip} link show "$I" >/dev/null 2>&1 || ${ip} link add "$I" type ifb
    ${ip} link set "$I" up

    # Egress: shape the upload side of the WAN link
    ${tc} qdisc replace dev "$W" root cake bandwidth ${toString cfg.uploadMbit}mbit ${egressOpts}

    # Ingress: redirect everything arriving on WAN into the IFB, then shape it
    ${tc} qdisc add dev "$W" handle ffff: ingress 2>/dev/null || true
    ${tc} filter del dev "$W" parent ffff: 2>/dev/null || true
    ${tc} filter add dev "$W" parent ffff: protocol all prio 10 matchall \
      action mirred egress redirect dev "$I"
    ${tc} qdisc replace dev "$I" root cake bandwidth ${toString cfg.downloadMbit}mbit ${ingressOpts}
  '';

  stopScript = pkgs.writeShellScript "trafficctl-stop" ''
    W="${wan}"
    I="${ifb}"
    ${tc} qdisc del dev "$W" root 2>/dev/null || true
    ${tc} qdisc del dev "$W" ingress 2>/dev/null || true
    ${tc} qdisc del dev "$I" root 2>/dev/null || true
    ${ip} link del "$I" 2>/dev/null || true
  '';

in
{
  options.services.trafficctl = {
    enable = lib.mkEnableOption "CAKE-based traffic shaping so bulk transfers don't ruin interactive latency";

    wanInterface = lib.mkOption {
      type = lib.types.str;
      example = "enp2s0";
      description = "Name of the WAN-facing interface (see `ip -br link`).";
    };

    ifbName = lib.mkOption {
      type = lib.types.str;
      default = "ifb0";
      description = "IFB device used for ingress shaping.";
    };

    downloadMbit = lib.mkOption {
      type = lib.types.ints.positive;
      default = 54;
      description = "Ingress shaping rate. About 90% of your advertised 60 Mbit.";
    };

    uploadMbit = lib.mkOption {
      type = lib.types.ints.positive;
      default = 9;
      description = "Egress shaping rate. About 90% of your advertised 10 Mbit.";
    };

    bulkTcpPorts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "6881-6889" "51413" ];
      description = ''
        TCP ports whose traffic is marked as bulk (CS1), which CAKE's diffserv4
        places in its lowest-priority tier. Matches both source and destination,
        so it covers your torrent client's listening port and its peers.
      '';
    };

    bulkUdpPorts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "6881-6889" "51413" ];
      description = "UDP ports marked as bulk (BitTorrent DHT and uTP).";
    };

    priorityTcpPorts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "22" ];
      description = "TCP ports marked as latency-sensitive (EF). Add game or VoIP ports here.";
    };

    priorityUdpPorts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "53" ];
      description = "UDP ports marked as latency-sensitive (EF). Add game ports here.";
    };

    tcpBbr = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use BBR congestion control. It pairs well with CAKE.";
    };

    extraEgressOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "docsis" ];
      description = ''
        Extra CAKE keywords for the upload side. Set the link overhead if you
        know your line type: "docsis" for most cable, "pppoe-ptm" for VDSL with
        PPPoE, "ethernet" for plain Ethernet.
      '';
    };

    extraIngressOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra CAKE keywords for the download side.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.wanInterface != "";
        message = "services.trafficctl.wanInterface must be set to your WAN interface name.";
      }
    ];

    boot.kernelModules = [ "ifb" "sch_cake" ] ++ lib.optional cfg.tcpBbr "tcp_bbr";
    boot.extraModprobeConfig = "options ifb numifbs=1";

    boot.kernel.sysctl = {
      # Keep unsent data in the socket buffer small so upload bufferbloat stays low
      "net.ipv4.tcp_notsent_lowat" = 16384;
    } // lib.optionalAttrs cfg.tcpBbr {
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    # DSCP marking needs nftables, and this also replaces the iptables firewall backend
    networking.nftables.enable = true;
    networking.nftables.tables.trafficctl = {
      family = "inet";
      content = ''
        chain postrouting {
          # Runs before the packet reaches tc on the WAN interface, so the
          # DSCP marks are visible to CAKE's diffserv4 classifier.
          type filter hook postrouting priority mangle; policy accept;

          # Bulk first, so the priority rules below overwrite them where ports overlap
          ${markRules { proto = "tcp"; ports = cfg.bulkTcpPorts; dscp = "cs1"; }}
          ${markRules { proto = "udp"; ports = cfg.bulkUdpPorts; dscp = "cs1"; }}

          ${markRules { proto = "tcp"; ports = cfg.priorityTcpPorts; dscp = "ef"; }}
          ${markRules { proto = "udp"; ports = cfg.priorityUdpPorts; dscp = "ef"; }}
        }
      '';
    };

    systemd.services.trafficctl = {
      description = "CAKE traffic shaping (egress on ${wan}, ingress via ${ifb})";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = startScript;
        ExecStop = stopScript;
      };
    };
  };
}

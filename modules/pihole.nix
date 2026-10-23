{ pkgs, ... }:
let
  hasIPv6Internet = false;
  StateDirectory = "dnscrypt-proxy";
in {

# Unbound was here
# It has proven itself successful in the goal of being a failure

    # See https://wiki.nixos.org/wiki/Encrypted_DNS
  services.dnscrypt-proxy = {
    enable = true;
    # See https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml
    settings = {
      listen_addresses = [ "127.0.0.1:51" ];
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3"; # See https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
        cache_file = "/var/lib/${StateDirectory}/public-resolvers.md";
      };

      # Use servers reachable over IPv6 -- Do not enable if you don't have IPv6 connectivity
      ipv6_servers = hasIPv6Internet;
      block_ipv6 = ! (hasIPv6Internet);

      require_dnssec = true;
      require_nolog = false;
      require_nofilter = true;

      # If you want, choose a specific set of servers that come from your sources.
      # Here it's from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      # If you don't specify any, dnscrypt-proxy will automatically rank servers
      # that match your criteria and choose the best one.
      # server_names = [ ... ];
    };
  };

  systemd.services.dnscrypt-proxy.serviceConfig.StateDirectory = StateDirectory;

  services.pihole-web = {
    enable = true;
    ports = [
      "80r"
      "443s"
    ];
  };

  services.pihole-ftl = {
    enable = true;
    package = pkgs.pihole-ftl;

    openFirewallDNS = true;
    openFirewallWebserver = true;

    lists = [
      {
        url = "https://easylist.to/easylist/easylist.txt";
        type = "block";
        enabled = true;
        description = "EasyList";
      }
      {
        url = "https://easylist.to/easylist/easyprivacy.txt";
        type = "block";
        enabled = true;
        description = "EasyPrivacy";
      }
      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        type = "block";
        enabled = true;
        description = "Steven Black Hosts";
      }
    ];

    # 1 = hide domains, keep clients -> per-host usage stats without seeing what they visit
    privacyLevel = 1;

    queryLogDeleter = {
      enable = true;
      interval = "weekly";
      age = 7;
    };

    settings = {
      dns = {
        upstreams = [
          "127.0.0.1#51"
        ];
        listeningMode = "ALL"; # answer on all interfaces
        interface = "";
        queryLogging = false; # no dnsmasq-style query log
        blockESNI = true;
        CNAMEdeepInspect = true;
        domain = "lan";
        cache.size = 10000;
        blocking = {
          active = true;
          mode = "NULL";
        };
      };

      dhcp.active = false;
      ntp = {
        ipv4.active = false;
        ipv6.active = false;
        sync.active = false;
      };
    };
  };
}

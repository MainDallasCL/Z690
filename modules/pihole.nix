{ pkgs, ... }:
{
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
          "8.8.8.8"
          "8.8.4.4"
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

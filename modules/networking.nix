{
  lib,
  ...
}:
{
  networking.networkmanager = {
    enable = true;
    dns = "none";
  };

  networking.useDHCP = false;
  networking.dhcpcd.enable = false;

  networking.nameservers = lib.mkDefault [ "192.168.2.175" ];

  services.tailscale = {
    enable = true;
    # Enable tailscale at startup

    # Stop Tailscale from overriding DNS with its own (MagicDNS) settings.
    extraSetFlags = [ "--accept-dns=false" ];

    # If you would like to use a preauthorized key
    #authKeyFile = "/run/secrets/tailscale_key";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
}

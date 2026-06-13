{
  inputs, lib, config, pkgs, ...
}:{
  networking.hostName = "Z690";
  networking.networkmanager.enable = true;

  # Disable NetworkManager's internal DNS resolution
  #networking.networkmanager.dns = "none";
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;

  services.tailscale = {
    enable = true;
    # Enable tailscale at startup

    # If you would like to use a preauthorized key
    #authKeyFile = "/run/secrets/tailscale_key";

  };
}

{ config, pkgs, inputs, ... }:

{
  imports = [ inputs.niri.nixosModules.niri ];
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  programs.niri.package = pkgs.niri;

  programs.niri.enable = true;

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.swaylock = {};

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # If you use greetd:
  #services.greetd = {
  #   enable = true;
  #   settings.default_session = {
  #     command = "${config.programs.niri.package}/bin/niri-session";
  #     user = "dallas";
  #  };
  #};
  #systemd.user.services.niri.enableDefaultPath = false;
}

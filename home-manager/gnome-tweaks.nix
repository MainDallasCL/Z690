# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      accent-color = "orange";
    };
    "org/gnome/shell" = { 
        enabled-extensions = [
          pkgs.gnomeExtensions.blur-my-shell.extensionUuid
          pkgs.gnomeExtensions.gjs-osk.extensionUuid
        ];
    };
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
        picture-uri = "file:///home/dallas/nixZ690/home-manager/wallpaper.jpg";
    };
    "org/gnome/desktop/background" = {
      picture-uri-dark = "file:///home/dallas/Z690/home-manager/wallpaper.jpg";
    };
  };
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "26.05";
}


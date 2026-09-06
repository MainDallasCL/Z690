{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

let
  myPackages = import ../../packages.nix { inherit pkgs; };
  # noctalia = cmd: [
  #   "noctalia-shell" "ipc" "call"
  # ] ++ (pkgs.lib.splitString " " cmd);
in
{
  imports = [
    inputs.niri.homeModules.niri
    ./modules/animations.nix
    ./modules/input.nix
    ./modules/keybind.nix
    ./modules/layout.nix
    ./modules/output.nix
    ./modules/window-rule.nix
  ];

  home.packages = myPackages;

  # home.pointerCursor = {
  #   # package = pkgs.bibata-cursors;
  #   name = "MacTahoe-dark";
  #   size = 20;
  #   x11.enable = true;
  #   gtk.enable = true;
  # };

  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      includes = lib.mkAfter [
          (./modules/blur.kdl)
        ];
      # blur = {
      #   passes = 2;
      #   offset = 3.0;
      #   noise = 0.03;
      #   saturation = 1.0;
      # };

      # Environment variables
      environment = {
        NIXOS_OZONE_WL = "1";
	      QT_QPA_PLATFORMTHEME = "qt6ct";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_STYLE_OVERRIDE = lib.mkForce "";
        MOZ_ENABLE_WAYLAND = "1";
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_DESKTOP = "niri";
      };

      # Spawn at startup
      spawn-at-startup = [
        { command = ["polkit-gnome-authentication-agent-1"]; }
        { command = ["gnome-keyring-daemon" "--start" "--components=pkcs11,secrets,ssh,pgp"]; }
        { command = ["swaybg" "-m" "fill" "-i" "${config.home.homeDirectory}/.config/nixos/home/themes/wallpapers/wallbler.jpg"]; }
        { command = ["xwayland-satellite"]; }
        { command = ["hypridle"]; }
        { command = ["wl-paste" "--watch" "cliphist" "store"]; }
        # { command = ["mpvpaper" "-o" "hwdec=vaapi loop=inf" "*" "${config.home.homeDirectory}/Downloads/Chisa720.mp4"]; }
      ];

      # Cursor settings
      cursor = {
        theme = "MacTahoe-dark";
        size = 24;
        hide-when-typing = true;
        hide-after-inactive-ms = 3919;
      };

      # Screenshot settings
      screenshot-path = "~/Pictures/Screenshots/Screenshot_niri_%Y-%m-%d_%H-%M-%S.png";

      # Hotkey daemon
      hotkey-overlay = {
        skip-at-startup = true;
      };

      # Prefer no CSD
      prefer-no-csd = true;
    };
  };
}

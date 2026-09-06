{ 
  inputs,
  pkgs,
  lib,
  config, 
  ... 
}:

let
  myPackages = import ../../packages.nix { inherit pkgs; };
in

{
  imports = [
  #   ./modules/animation.nix
    ./modules/hyprlock.nix
    ./modules/hypridle.nix
  #   ./modules/keybinds.nix
  ];

  waybar.enable = true;

  # Apply GTK/Qt themes to Hyprland session
  # home.sessionVariables = {
  #   GDK_BACKEND = "wayland,x11";
  #   QT_QPA_PLATFORM_THEME = "gtk3";
  #   QT_STYLE_OVERRIDE = "gtk2";
  #   XCURSOR_THEME = "Bibata-Modern-Ice";
  #   XCURSOR_SIZE = "20";
  # };

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  #   portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  #   configType = "lua";

    # settings = {
    #   exec-once = [
    #     # "noctalia-shell"
    #     "hyprctl setcursor Bibata-Modern-Ice 20"
    #     "waybar"
    #     "swaybg -m fill -i ~/.config/nixos/home/themes/wallpapers/MacTahoeDark.jpg"
    #   ];
    #
    #   general = {
    #     gaps_in = 5;
    #     gaps_out = 10;
    #     border_size = 0;
    #     layout = "dwindle";
    #   };
    #
    #   decoration = {
    #     rounding = 10;
    #     blur = {
    #       enabled = true;
    #       size = 3;
    #       passes = 2;
    #       vibrancy = 0.1696;
    #     };
    #     shadow = {
    #       enabled = true;
    #       range = 4;
    #       render_power = 3;
    #       color = "rgba(1a1a1aee)";
    #     };
    #   };
    #
    #   input = {
    #     kb_layout = "us";
    #     kb_model = "chromebook";
    #     follow_mouse = 1;
    #     sensitivity = 0.0;
    #     touchpad = {
    #       natural_scroll = true;
    #     };
    #   };
    #
    #   dwindle = {
    #     pseudotile = true;
    #     preserve_split = true;
    #   };
    #
    #   # windowrule = [
    #   #   "float,^(pavucontrol)$"
    #   #   "float,^(blueman-manager)$"
    #   # ];
    # };
  # };
}

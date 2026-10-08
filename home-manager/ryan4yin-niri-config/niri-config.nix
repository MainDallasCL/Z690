# Niri config adapted from https://github.com/ryan4yin/nix-config (MIT).
#
# Like the original, this does NOT use `programs.niri` (that option only exists
# in niri-flake's home-manager module). It just drops the KDL config into
# ~/.config/niri/ with plain `xdg.configFile`.
#
# The files in ./niri/ are concatenated into a single config.kdl instead of
# using `include`, because `include` needs niri >= 25.11 and the niri-flake
# overlay in modules/niri.nix currently provides v25.08.
{ lib, pkgs, ... }:
let
  kdlFiles = [
    ./niri/config.kdl
    ./niri/keybindings.kdl
    ./niri/windowrules.kdl
    ./niri/noctalia.kdl
    ./niri/outputs.kdl
  ];
in
{
  programs.alacritty.enable = true;

  xdg.configFile."niri/config.kdl".text =
    lib.concatMapStringsSep "\n" builtins.readFile kdlFiles;

  home.packages = with pkgs; [
    playerctl   # media keys
  ];
}

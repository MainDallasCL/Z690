# Noctalia shell from the upstream flake (home-manager release-26.05 has no
# built-in programs.noctalia). Started by niri (see niri/noctalia.kdl), so the
# systemd service stays off. The config is validated at build time.
{ inputs, ... }:
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    settings = ./noctalia/config.toml;
  };

  # Wallpapers from ryan4yin/wallpapers, in their own subfolder so an existing
  # ~/Pictures/Wallpapers is left alone.
  home.file."Pictures/Wallpapers/ryan4yin".source = inputs.wallpapers;
}

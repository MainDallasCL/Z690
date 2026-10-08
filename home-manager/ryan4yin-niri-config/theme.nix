# Catppuccin Mocha / pink, as in ryan4yin/nix-config, but opt-in per app so
# nothing you already configured (firefox, vscode, neovim, mangohud...) is
# restyled behind your back. Add more ports as `catppuccin.<app>.enable = true`.
{ inputs, pkgs, ... }:
{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  catppuccin = {
    flavor = "mocha";
    accent = "pink";
    cache.enable = false;

    alacritty.enable = true;
    fish.enable = true;
    mpv.enable = true;
    imv.enable = true;
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  gtk = {
    enable = true;
    font = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
      size = 11;
    };
  };
}

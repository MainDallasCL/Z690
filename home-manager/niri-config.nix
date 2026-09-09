{
  pkgs,
  ...
}: {
  programs = {
    alacritty.enable = true;
  };
  programs.niri = {
    #enable = true;
    settings = {
      prefer-no-csd = true;
      input = {
        touchpad = {
          tap = true;
          natural-scroll = true;
        };
        # trackpoint = { ... };
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "0%";
        };
      };
      layout = {
        gaps = 8;
      };
      binds = {
        "Mod+T".action.spawn = "alacritty";
        "Mod+D".action.spawn = "fuzzel";
      };
    };
  };
}

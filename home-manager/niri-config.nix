{
  pkgs,
  ...
}: {
  programs = {
    alacritty.enable = true;
  };
  programs.niri = {
    # We don't enable niri here explicitly, as it was already enabled it prior
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

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
          # Optional – highly recommended on a scrolling compositor
          # so it doesn’t jump the view when the cursor crosses a partially-offscreen window
          max-scroll-amount = "0%";
        };
      };
      layout = {
        gaps = 8;
        # ... same as above
      };
      binds = {
        "Mod+T".action.spawn = "alacritty";
        "Mod+D".action.spawn = "fuzzel";
        # etc.
      };
    };
  };
}

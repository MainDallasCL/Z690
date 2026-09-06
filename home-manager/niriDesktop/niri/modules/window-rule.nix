{
  ...
}:
{
  programs.niri = {
    settings = {
      window-rules = [
        {
          matches = [
            {is-window-cast-target = true;}
          ];
          focus-ring = {
            active = {color = "#f38ba8";};
            inactive = {color = "#7d0d2d";};
          };
          border = {
            inactive = {color = "#7d0d2d";};
          };
          shadow = {
            color = "rgba(0, 0, 0, 0.5)";
            spread = 4;
          };
          tab-indicator = {
            active = {color = "#f38ba8";};
            inactive = {color = "#7d0d2d";};
          };
        }
        {
          geometry-corner-radius = {
            top-left = 12.0;
            top-right = 12.0;
            bottom-left = 12.0;
            bottom-right = 12.0;
          };
          clip-to-geometry = true;
          draw-border-with-background = false;
        }
      ];
    };
  };
}

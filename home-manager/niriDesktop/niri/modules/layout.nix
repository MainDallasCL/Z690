{
  ...
}:
{
  programs.niri = {
    settings = {
      layout = {
        gaps = 12;
        always-center-single-column = true;
        preset-column-widths = [
          { proportion = 0.333; }
          { proportion = 0.5; }
          { proportion = 0.667; }
        ];
        default-column-width = { proportion = 0.9; };
        focus-ring = {
          enable = true;
          width = 1;
          active.color = "rgb(59 130 246)";
          inactive.color = "rgb(89 89 89)";
        };
        border = {
          enable = true;
          width = 1;
          active.color = "rgb(59 130 246)";
          inactive.color = "rgba(89, 89, 89, 0.5)";
        };
      };
    };
  };
}

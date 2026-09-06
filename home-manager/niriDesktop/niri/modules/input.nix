{
  ...
}:
{
  programs.niri = {
    settings = {
      input = {
        keyboard = {
          xkb = {
            layout = "us";
            model = "chromebook";
          };
          repeat-delay = 300;
          repeat-rate = 50;
        };

        touchpad = {
          tap = true;
          natural-scroll = true;
        };

        mouse = {
          accel-speed = 0.8;
        };
      };
    };
  };
}

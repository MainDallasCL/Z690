{
  ...
}:
{
  programs.niri = {
    settings = {
      outputs = {
        "eDP-1" = {
          mode = {
            width = 1366;
            height = 768;
            refresh = 60.0;
          };
          position = { x = 0; y = 0; };
          scale = 1.0;
          #scale = 0.85;
        };
      };
    };
  };
}

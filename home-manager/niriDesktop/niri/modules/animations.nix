{ 
 ...
}:

{
  programs.niri = {
    settings = {
      animations = {
        slowdown = 1.0;

        window-open = {
          kind.spring = {
            damping-ratio = 0.8;
            stiffness = 1000;
            epsilon = 0.0001;
          };
        };

        config-notification-open-close = {
          kind.spring = {
            damping-ratio = 0.6;
            stiffness = 1000;
            epsilon = 0.001;
          };
        };
      };
    };
  };
}

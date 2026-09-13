{ 
  config, 
  pkgs, 
  callPackage, 
  ... 
}: {
  nixpkgs.config.pulseaudio = true;

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };
  services.displayManager.defaultSession = "xfce";
}


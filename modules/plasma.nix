{
  inputs, lib, config, pkgs, ...
}:{
  # Enable Plasma 
  services = {
    desktopManager.plasma6.enable = true;

  # Default display manager for Plasma
    displayManager.plasma-login-manager.enable = true;

  # Optionally enable xserver, but I won't ;^)
  # xserver.enable = true;
  };
}

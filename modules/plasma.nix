{
  ...
}:{
  # Do stupid fucking dumb bullshit so kde doesn't touch my little nvidia for fucks sake
  hardware.nvidia.modesetting.enable = false;
  services.udev.extraRules = ''
    SUBSYSTEM=="drm", KERNEL=="card[0-9]*", KERNELS=="0000:00:02.0", SYMLINK+="dri/igpu"
    SUBSYSTEM=="drm", KERNEL=="renderD*", KERNELS=="0000:00:02.0", SYMLINK+="dri/render-igpu"
  '';
  environment.variables.KWIN_DRM_DEVICES = "/dev/dri/igpu";
  environment.variables.KWIN_RENDER_NODES = "/dev/dri/render-igpu";
  # Enable Plasma
  services = {
    desktopManager.plasma6.enable = true;

  # Default display manager for Plasma
    displayManager.plasma-login-manager.enable = true;
    displayManager.defaultSession = "plasma";

  # Optionally enable xserver, but I won't ;^)
  # xserver.enable = true;
  };
}

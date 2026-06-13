{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
#      nvidia-vaapi-driver
#      nv-codec-headers-12
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
    nvidiaSettings = true;

    package =
      config.boot.kernelPackages.nvidiaPackages.latest;
  };

  environment.sessionVariables = {
    NVD_BACKEND = "direct";
  };
}

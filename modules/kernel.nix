{
  lib, pkgs, ...
}:{
  # Custom Kernel
  #boot.kernelPackages = lib.mkDefault pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.availableKernelModules = [ "f2fs" ];
}

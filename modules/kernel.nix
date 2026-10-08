{
  inputs, lib, config, pkgs, ...
}:{
  # Custom Kernel
  #nix.settings.substituters = [ "https://cache.xinux.uz" ];
  #nix.settings.trusted-public-keys = [ "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0=" ];
  #boot.kernelPackages = lib.mkDefault pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.availableKernelModules = [ "f2fs" ];
}

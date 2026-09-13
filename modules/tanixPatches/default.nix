# Disables the Bootloader completely, and just writes new extlinux files
# That's for the best, the default uboot won't boot on my board
# I had to splice in Armbian's bootloader for the thing to boot

{
  pkgs, ...
}:{
  #nixpkgs.overlays = [ (import ./nixos-rebuild-wrapper.nix) ];

  hardware.deviceTree = {
    enable = true;
    name = "allwinner/sun50i-h6-tanix-tx6.dtb";
  };
#  hardware.enableRedistributableFirmware = true;
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible = {
    enable = true;
#    configurationLimit = 10;
    useGenerationDeviceTree = true;
  };
#  boot.initrd.includeDefaultModules = false;
#  boot.initrd.systemd.enable = false;

  #boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./armbian-kernel.nix { });
}

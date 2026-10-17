{ lib, ... }:
{
  specialisation.vfio.configuration = {
    system.nixos.tags = [ "vfio" ];

    boot.initrd.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];
    boot.kernelParams = [
      "vfio-pci.ids=10de:2484,10de:228b"
      # add "intel_iommu=on" or "amd_iommu=on" if not already set
    ];
    boot.blacklistedKernelModules = [
      "nvidia" "nvidia_drm" "nvidia_modeset" "nvidia_uvm" "nouveau" "nvidiafb"
    ];

    # Keep the desktop on the iGPU and off nvidia
    services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];
    #hardware.nvidia.enable = lib.mkForce false;
  };
}

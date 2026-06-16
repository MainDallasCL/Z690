{
  inputs, lib, config, pkgs, ...
}: {
  imports = [
    # NixOS specific things
    ./modules/nixpkgs.nix

    # Partitions
    ./hardware-configuration.nix
    ./modules/partitions.nix

    # Hardware
    ./modules/nvidia.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    # Peripherals
    ./modules/BENQ.nix
    ./modules/M2070.nix

    # Bootloader and Kernel
    ./modules/systemd-boot.nix
    ./modules/kernel.nix

    # Operating System
    ./modules/kexec.nix
    ./modules/swap.nix
    ./modules/locale.nix
    ./modules/keyboard.nix
    ./modules/sound.nix
    ./modules/networking.nix
    ./modules/locale.nix
    ./modules/ssh.nix
    ./modules/sunshine.nix

    # User space
    ./modules/users.nix
    #./modules/gnome.nix
    ./modules/plasma.nix
    ./modules/applications.nix
    ./modules/nixflix.nix

    # Virtual Machines
    ./modules/virt-manager.nix

    # Sandboxed applications
    ./modules/sandboxed-apps
  ];
  system.stateVersion = "26.05";
}

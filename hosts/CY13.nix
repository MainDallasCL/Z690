{
  inputs, lib, config, pkgs, ...
}: {
  imports = [
    # NixOS specific things
    ../modules/nixpkgs.nix

    # Partitions
    ../modules/CY13-partitions.nix

    # Hardware
    # Everything literally works xD

    # Peripherals
    # Or a lack thereof

    # Bootloader and Kernel
    ../modules/systemd-boot.nix
    ../modules/kernel.nix

    # Operating System
    ../modules/kexec.nix
    ../modules/swap.nix
    ../modules/locale.nix
    ../modules/keyboard.nix
    ../modules/sound.nix
    ../modules/networking.nix
    ../modules/locale.nix
    ../modules/ssh.nix

    # User space
    ../modules/users.nix
    ../modules/plasma.nix
    ../modules/applications.nix
  ];
  system.stateVersion = "26.05";
}

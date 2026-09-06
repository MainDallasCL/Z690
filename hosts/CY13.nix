{ inputs, lib, config, pkgs, ...
}:
let
  mod = name: ../modules + "/${name}";
in {
  imports = map mod [
    # NixOS specific things
    "nixpkgs.nix"

    # Partitions
    "CY13-partitions.nix"

    # Hardware
    "battery-managment.nix"

    # Peripherals
    # Or a lack thereof

    # Bootloader and Kernel
    "systemd-boot.nix"
    "kernel.nix"

    # Operating System
    "kexec.nix"
    "swap.nix"
    "locale.nix"
    "chromebook-keyboard.nix"
    "sound.nix"
    "networking.nix"
    "ssh.nix"

    # User space
    "users.nix"

    "plasma.nix"
    #"niri.nix"
    "applications.nix"
  ];
  system.stateVersion = "26.05";
}

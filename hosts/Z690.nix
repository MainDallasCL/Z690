let
  mod = name: ../modules + "/${name}";
in {
  imports = map mod [
    # NixOS specific things
    "nixpkgs.nix"

    # Partitions
    "Z690-partitions.nix"

    # Hardware
    "nvidia.nix"

    # Peripherals
    "BENQ.nix"
    "M2070.nix"

    # Bootloader and Kernel
    "systemd-boot.nix"
    "kernel.nix"

    # Operating System
    "kexec.nix"
    "swap.nix"
    "locale.nix"
    "keyboard.nix"
    "sound.nix"
    "networking.nix"
    "ssh.nix"
    "sunshine.nix"

    # User space
    "users.nix"
    "plasma.nix"
    "applications.nix"
    "nixflix.nix"
    "flatpak.nix"
    "freenet.nix"

    # Virtual Machines
    "virt-manager.nix"

    # Sandboxed applications
    "sandboxed-apps"
  ];
  system.stateVersion = "26.05";
}

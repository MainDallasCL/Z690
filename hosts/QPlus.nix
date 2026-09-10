{
  pkgs, ...
}:
let
  mod = name: ../modules + "/${name}";
in {
  imports = map mod [
    # NixOS specific things
    "nixpkgs.nix"

    # Partitions
    "partitions/QPlus-partitions.nix"

    # Hardware

    # Bootloader and Kernel
    # TODO Self explanatory

    # Operating System
    "kexec.nix"
    "swap.nix"
    "locale.nix"
    "networking.nix"
    "ssh.nix"

    # User space
    "users.nix"
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  programs = {
    fish.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  system.stateVersion = "26.05";
}


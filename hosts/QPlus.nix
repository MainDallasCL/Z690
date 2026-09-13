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
    "tanixPatches"

    # Operating System
    "kexec.nix"
    "swap.nix"
    "locale.nix"
    "networking.nix"
    #"ssh.nix" Slightly different for now

    # User space
    "users.nix"
    "xfce4.nix"
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

  programs.git.enable = true;

  system.stateVersion = "26.05";
}


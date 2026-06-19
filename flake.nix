{
  description = "Z690 config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    # CachyOS kernel for NixOS
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    # NixOS hardware
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixPak the backbone of sandboxing here
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixFlix for pirated movies
    nixflix = {
      url = "github:kiriwalawren/nixflix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-cachyos-kernel,
    nixos-hardware,
    nixpak,
    nixflix,
    ...
  } @ inputs: let
    userArgs = import ./specialArgs.nix;
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      Z690 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; } // userArgs;
        modules = [
          {
            nixpkgs.overlays = [
              nix-cachyos-kernel.overlays.pinned
            ];
          }
          nixos-hardware.nixosModules.asus-zephyrus-gu603h
          nixflix.nixosModules.default
          ./hosts/Z690.nix
        ];
      };
    };

    homeConfigurations = {
      "dallas@Z690" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; 
        extraSpecialArgs = {inherit inputs;};
        modules = [./home-manager/home.nix];
      };
    };
  };
}

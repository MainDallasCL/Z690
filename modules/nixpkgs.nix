{
  inputs, lib, config, pkgs, ...
}: {
  nixpkgs = {
    overlays = [
      inputs.vintagestory-nix.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
    };
    channel.enable = false;
  };
}

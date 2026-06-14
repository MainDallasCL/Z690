{
  inputs, lib, config, pkgs, ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.asus-zephyrus-gu603h
  ];
}

{ pkgs, inputs, username, ... }:

let
  nixpak = inputs.nixpak;
  utils = import ./nixpak { inherit pkgs nixpak username; };
  sandboxedXdgUtils = pkgs.callPackage ./nixpak/xdg-utils.nix { };
  call = file: import file { inherit pkgs utils sandboxedXdgUtils inputs username; };

  minecraft = call ./minecraft.nix;
in
{

  users.users.${username}.packages = [
    minecraft
  ];
}

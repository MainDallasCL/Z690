{
  inputs, lib, config, pkgs, ...
}:{
  nixpkgs.config.allowUnfree = true;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.samsung-unified-linux-driver ];
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.samsung-unified-linux-driver ];
}

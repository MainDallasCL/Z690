{
  inputs, lib, config, pkgs, ...
}:{
  services.printing.enable = true;
  services.ipp-usb.enable = true;
  services.printing.drivers = [ pkgs.samsung-unified-linux-driver ];
}

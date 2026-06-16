{
  inputs, lib, config, pkgs, ...
}:{
  nixpkgs.config.allowUnfree = true;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.samsung-unified-linux-driver ];
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.samsung-unified-linux-driver ];

  hardware.printers.ensurePrinters = [
  {
    name = "M2070";
    location = "Right Here";
    deviceUri = "usb://Samsung/M2070%20Series?serial=ZF44BJCH6000LKD&interface=1";
    model = "samsung/M267x.ppd";
    ppdOptions = {
      PageSize = "A4";
    };
  }
];
}

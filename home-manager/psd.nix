{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.psd.enable = false;
  services.psd.browsers = [
    "firefox"
  ];
}

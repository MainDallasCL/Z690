{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
  };
  services.psd.enable = false;
  services.psd.browsers = [
    "firefox"
  ];
}

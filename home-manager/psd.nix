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
  services.psd.enable = true;
  services.psd.browsers = [
    "firefox"
  ];
}

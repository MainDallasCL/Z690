{
  inputs, lib, config, pkgs, nixflix, ...
}: {
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}

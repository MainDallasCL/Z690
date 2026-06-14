{
  inputs, lib, config, pkgs, nixflix, ...
}: {
  nixflix = {
    enable = true;
    jellyfin.openFirewall = true;
    mediaDir = "/mnt/nvRAID/SHARED/Media";
    stateDir = "/var/lib";
    jellyfin = {
      apiKey = "0123456789abcdef0123456789abcdef";
      enable = true;
      users = {
        "dallas" = {
          password = "tak";
          policy = {
            isAdministrator = true;
          };
        };
      };
    };
  };
}

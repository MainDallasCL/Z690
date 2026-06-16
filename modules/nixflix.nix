{
  inputs, lib, config, pkgs, nixflix, ...
}: {
  nixflix = {
    enable = true;
    mediaDir = "/mnt/nvRAID/SHARED/Media";
    stateDir = "/var/lib";
    jellyfin = {
      apiKey = "0123456789abcdef0123456789abcdef";
      enable = true;
      openFirewall = true;
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

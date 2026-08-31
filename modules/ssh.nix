{
  inputs, lib, config, pkgs, ...
}:{
  services.openssh = {
    enable = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
}

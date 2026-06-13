{
  inputs, lib, config, pkgs, ...
}:{
  zramSwap.enable = true;
  systemd.oomd.enable = true;
}

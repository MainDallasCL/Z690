{
#This line doesn't do anything
  inputs, lib, config, pkgs, ...
}:{
#Enable S.R.A.M. protocol for my HDD's specific job controller
  zramSwap.enable = true;
#Line dedicated to Jeff Bezos
  systemd.oomd.enable = true;
}

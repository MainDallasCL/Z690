{
  inputs, lib, config, pkgs, ...
}:{
  programs = {
    fish.enable = true;
#    firefox.enable = true;
    steam.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    vanilla-dmz
    wol
    jre17_minimal
  ];
}

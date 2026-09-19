{
  pkgs, ...
}:{
  programs = {
    fish.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    vanilla-dmz
    wol
    jre17_minimal
    nil
  ];
}

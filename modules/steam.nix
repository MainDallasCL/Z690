{
  ...
}:{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession = {
        # Optimized micro-compositor. Use the Steam launch option: gamescope %command%
        enable = true;
    };
  };

  hardware.steam-hardware.enable = true;
}

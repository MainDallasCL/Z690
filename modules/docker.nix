{
  virtualisation.docker = {
    # Consider disabling the system wide Docker daemon
    enable = false;

    rootless = {
      enable = true;
      setSocketVariable = true;
      # Optionally customize rootless Docker daemon settings
      daemon.settings = {
        data-root = "~/.local/docker";
        dns = [ "127.0.0.1" ];
        registry-mirrors = [ "https://mirror.gcr.io" ];
      };
    };
  };
}

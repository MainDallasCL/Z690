{
  inputs,
  ...
}:
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
    ../danksearch
  ];

  programs.dank-material-shell = {
    enable = true;
    niri = {
      enableKeybinds = false;
      enableSpawn = true;
    };
    enableSystemMonitoring = true;
    # dgop.package = inputs.dgop.packages.${pkgs.system}.default;
  };
}

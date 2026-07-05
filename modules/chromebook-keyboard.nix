{
  inputs, lib, config, pkgs, ...
}:{
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
    model = "chromebook";
  };

  # Configure console keymap
  console.keyMap = "pl2";
}

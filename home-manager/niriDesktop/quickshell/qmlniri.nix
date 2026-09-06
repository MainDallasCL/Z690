{ pkgs, inputs, ... }:

let
  # 1. Grab the compiled qml-niri plugin from your new flake input
  qmlNiriPkg = inputs.qml-niri.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # 2. Define the base Quickshell package provided by DMS
  # Update this reference if DMS stores it differently!
  baseQuickshell = pkgs.quickshell; 

  # 3. Create a wrapper that injects the plugin path
  quickshellWithNiri = pkgs.symlinkJoin {
    name = "quickshell-niri-wrapped";
    paths = [ baseQuickshell ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/quickshell \
        --prefix QML2_IMPORT_PATH : "${qmlNiriPkg}/lib/qt-6/qml"
    '';
  };
in
{
  # Install your freshly wrapped version
  home.packages = [
    # quickshellWithNiri
    (pkgs.lib.hiPrio quickshellWithNiri)
  ];
}

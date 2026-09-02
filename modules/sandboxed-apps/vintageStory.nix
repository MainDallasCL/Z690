{ inputs, pkgs, utils, sandboxedXdgUtils, ... }:

let
  # Import the Vintage Story package from the flake
  vintagestory-pkg = pkgs.vintagestoryPackages.v1-21-6;

  # Create a wrapper package with executable and desktop entry
  wrapped-vintagestory = pkgs.symlinkJoin {
    name = "vintagestory";
    paths = [
      (
        pkgs.writeShellScriptBin "vintagestory" ''
          exec ${vintagestory-pkg}/bin/vintagestory "$@"
        ''
      )
      (pkgs.makeDesktopItem {
        name = "vintagestory";
        exec = "vintagestory";
        icon = "vintagestory";
        desktopName = "Vintage Story";
        comment = "Uncompromising wilderness survival sandbox game";
        categories = [ "Game" ];
      })
    ];
    postBuild = ''
      mkdir -p $out/share/pixmaps
      # Use the icon from the original package if available
      if [ -f "${vintagestory-pkg}/share/pixmaps/vintagestory.xpm" ]; then
        ln -s ${vintagestory-pkg}/share/pixmaps/vintagestory.xpm \
          $out/share/pixmaps/vintagestory.xpm
      else
        # Fallback to a generic game icon
        ln -s ${pkgs.fetchurl {
          url = "https://cdn2.steamgriddb.com/icon_thumb/66ad4d795e99fb554db14f094b47de9c.png";
          hash = "sha256-IbRIJ14CDL4gfQEgGSF72BmN01taFrKPFGSE9lYCl3Y=";
        }} $out/share/pixmaps/vintagestory.xpm
      fi
    '';
  };

in
utils.mkSandboxed {
  package = wrapped-vintagestory;
  name = "vintagestory";
  displayName = "Vintage Story";
  wmClass = "Vintagestory";

  # Additional packages needed for the sandbox
  extraPackages = [ sandboxedXdgUtils ];

  # Sandbox presets for optimal gaming experience
  presets = [
    "wayland"          # Wayland windowing system support
    "gpu"              # OpenGL/Hardware acceleration
    "audio"            # Game sound
    "network"          # Multiplayer and updates
    "portals"          # File dialogs and portals
  ];

  # Additional permissions for Vintage Story
  extraPerms = { sloth, ... }: {
    bubblewrap = {
      # Bind necessary directories read-write
      bind.rw = [
        (sloth.concat' sloth.homeDir "/.config/VintagestoryData")  # Game settings
        (sloth.concat' sloth.homeDir "/.config/Mono")  # Mono runtime config
        (sloth.concat' sloth.homeDir "/.local/share/Mono")  # Mono cache
      ];

      bind.ro = [
        "/etc/passwd"
        "/etc/group"
      ];

      # Bind device nodes for graphics and input
      bind.dev = [
        "/dev/dri"  # Direct rendering infrastructure
        "/dev/input"  # Input devices (keyboard, mouse, gamepad)
        "/dev/snd"  # Sound devices
      ];
    };

    # D-Bus policies for better desktop integration
    dbus = {
      enable = true;
      policies = {
        "org.freedesktop.DBus" = "talk";
        "com.canonical.Unity" = "talk";
        "org.freedesktop.Notifications" = "talk";
        "org.kde.StatusNotifierWatcher" = "talk";
      };
    };
  };
}

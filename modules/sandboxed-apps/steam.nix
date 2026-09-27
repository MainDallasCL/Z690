{ pkgs, utils, sandboxedXdgUtils, ... }:

let
  # pkgs.steam is already a buildFHSEnv wrapper that ships its own
  # desktop entry and icons, so unlike the Vintage Story module there's no
  # need for a symlinkJoin / makeDesktopItem wrapper. Override here if you
  # want extra runtime libs, e.g.:
  #   pkgs.steam.override { extraPkgs = p: [ p.gamemode ]; }
  steam-pkg = pkgs.steam;
in
utils.mkSandboxed {
  package = steam-pkg;
  name = "steam";
  displayName = "Steam";
  wmClass = "steam";

  extraPackages = [ sandboxedXdgUtils ];

  presets = [
    "wayland"
    "x11"       # Steam's client UI and most Proton games go through XWayland
    "gpu"
    "audio"
    "network"
    "portals"
  ];

  extraPerms = { sloth, ... }:
    let
      home = sloth.homeDir;
      # sloth.mkdir creates the directory first, so bwrap doesn't choke
      # on a first launch where nothing exists yet.
      homeDir = rel: sloth.mkdir (sloth.concat' home rel);
    in
    {
      # Nixpak-level env (not the FHS env's own)
      bubblewrap.env = {
        XDG_SESSION_TYPE = "wayland";
        # Needs the ntsync kernel module (6.14+, `boot.kernelModules = [ "ntsync" ]`)
        # PROTON_USE_NTSYNC = "1";
      };

      bubblewrap = {
        bind.rw = [
          # Steam itself
          (homeDir "/.steam")
          (homeDir "/.local/share/Steam")

          # Proton / umu prefixes and runtime
          (homeDir "/.local/share/umu")

          # Steam drops shortcuts and icons for installed games here
          (homeDir "/.local/share/applications")
          (homeDir "/.local/share/desktop-directories")
          (homeDir "/.local/share/icons")

          # Extra library folders: add whatever you use, e.g.
          # "/games/steam"
        ];

        bind.ro = [
          "/etc/passwd"
          "/etc/group"

          # SDL / Steam Input use the udev database to identify controllers
          "/run/udev"
        ];

        bind.dev = [
          "/dev/dri"
          "/dev/input"
          "/dev/snd"
          # Steam Input's virtual controllers; uncomment if remapping fails
          # "/dev/uinput"
          # Some controllers (DualSense, Switch Pro) need hidraw; if they
          # aren't detected, the blunt fix is `bind.dev = [ "/dev" ]`
        ];
      };

      dbus = {
        enable = true;
        policies = {
          "org.freedesktop.DBus" = "talk";
          "org.freedesktop.Notifications" = "talk";
          "org.freedesktop.ScreenSaver" = "talk";      # idle inhibit while gaming
          "org.kde.StatusNotifierWatcher" = "talk";    # tray icon
          "com.feralinteractive.GameMode" = "talk";

          # Steam registers itself and pressure-vessel on the session bus
          "com.valvesoftware.Steam" = "own";
          "com.valvesoftware.Steam.*" = "own";
          "com.steampowered.PressureVessel.*" = "own";
        };
      };
    };
}

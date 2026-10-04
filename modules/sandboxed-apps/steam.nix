{ pkgs, utils, sandboxedXdgUtils, ... }:

let
  steam-pkg = pkgs.steam;

  # The host's nvidia-offload isn't visible inside the sandbox, so ship an equivalent.
  # Use as a Steam launch option: nvidia-offload %command%
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
utils.mkSandboxed {
  package = steam-pkg;
  name = "steam";
  displayName = "Steam";
  wmClass = "steam";

  extraPackages = [ sandboxedXdgUtils nvidia-offload ];

  presets = [
    "wayland"
    "x11"
    "gpu"
    "audio"
    "network"
    "portals"
  ];

  extraPerms = { sloth, ... }:
    let
      home = sloth.homeDir;
      homeDir = rel: sloth.mkdir (sloth.concat' home rel);
    in
    {
      bubblewrap.env = {
        XDG_SESSION_TYPE = "wayland";
        # PROTON_USE_NTSYNC = "1";

        # Alternative to the per-game launch option: offload ALL of Steam
        # (UI included) to the dGPU. Uses more power, but needs no launch options.
        # __NV_PRIME_RENDER_OFFLOAD = "1";
        # __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
        # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        # __VK_LAYER_NV_optimus = "NVIDIA_only";
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

          # Extra library folders
          "/mnt/EXTRA/SHARED/Steam"
          "/mnt/RAID/SHARED/Steam"
          "/mnt/nvRAID/SHARED/Steam/"
        ];

        bind.ro = [
          "/etc/passwd"
          "/etc/group"
          "/run/udev"
        ];

        bind.dev = [
          "/dev/dri"
          "/dev/input"
          "/dev/snd"
          # "/dev/uinput"
        ];
      };

      dbus = {
        enable = true;
        policies = {
          "org.freedesktop.DBus" = "talk";
          "org.freedesktop.Notifications" = "talk";
          "org.freedesktop.ScreenSaver" = "talk";
          "org.kde.StatusNotifierWatcher" = "talk";
          "com.feralinteractive.GameMode" = "talk";

          "com.valvesoftware.Steam" = "own";
          "com.valvesoftware.Steam.*" = "own";
          "com.steampowered.PressureVessel.*" = "own";
        };
      };
    };
}

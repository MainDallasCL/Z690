# Desktop apps and services from ryan4yin/nix-config's GUI setup. Services that
# only make sense under niri are tied to niri.service so Plasma sessions are
# unaffected.
{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    # fonts used by Noctalia / terminals
    maple-mono.NF-CN-unhinted
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji

    app2unit           # launch desktop entries as systemd user units
    gpu-screen-recorder
    wf-recorder
    wl-clipboard
    pavucontrol
    pulsemixer
    playerctl
    imv                # image viewer
    foliate            # e-book reader
    remmina            # RDP/VNC client
    freerdp
  ];

  programs.mpv = {
    enable = true;
    defaultProfiles = [ "gpu-hq" ];
    scripts = [ pkgs.mpvScripts.mpris ];
  };

  # Emergency session menu; Noctalia's session panel is the normal one.
  programs.wlogout.enable = true;

  services.playerctld.enable = true;

  # Auto-mount USB drives (no tray icon; Noctalia shows the notifications).
  services.udiskie = {
    enable = true;
    tray = "never";
  };
  systemd.user.services.udiskie.Install.WantedBy = lib.mkForce [ "niri.service" ];

  # Idle: lock after 10 min, monitors off after 15 min; both skipped while an
  # MPRIS player is playing. Runs only in niri sessions.
  services.hypridle = {
    enable = true;
    systemdTarget = "niri.service";
    settings = {
      general = {
        lock_cmd = "noctalia msg session lock";
        before_sleep_cmd = "noctalia msg session lock";
        ignore_dbus_inhibit = true;
      };
      listener = [
        {
          timeout = 600;
          ignore_inhibit = true;
          condition_cmd = "! playerctl -a status 2>/dev/null | grep -q '^Playing$'";
          condition_retry = 30;
          on-timeout = "noctalia msg session lock";
        }
        {
          timeout = 900;
          ignore_inhibit = true;
          condition_cmd = "! playerctl -a status 2>/dev/null | grep -q '^Playing$'";
          condition_retry = 30;
          on-timeout = "niri msg action power-off-monitors";
          on-resume = "niri msg action power-on-monitors";
        }
      ];
    };
  };
}

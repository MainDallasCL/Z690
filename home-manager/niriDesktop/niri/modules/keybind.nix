{
  ...
}:
{
  programs.niri = {
    settings = {
      # binds = {
      # "Mod+Shift+Slash".action.show-hotkey-overlay = {};

      # # Movement
      # "Mod+Left".action.focus-column-left = {};
      # "Mod+Down".action.focus-window-down = {};
      # "Mod+Up".action.focus-window-up = {};
      # "Mod+Right".action.focus-column-right = {};
      # "Mod+H".action.focus-column-left = {};
      # "Mod+J".action.focus-window-down = {};
      # "Mod+K".action.focus-window-up = {};
      # "Mod+L".action.focus-column-right = {};

      # # Moving windows
      # "Mod+Ctrl+Left".action.move-column-left = {};
      # "Mod+Ctrl+Down".action.move-window-down = {};
      # "Mod+Ctrl+Up".action.move-window-up = {};
      # "Mod+Ctrl+Right".action.move-column-right = {};
      # "Mod+Ctrl+H".action.move-column-left = {};
      # "Mod+Ctrl+J".action.move-window-down = {};
      # "Mod+Ctrl+K".action.move-window-up = {};
      # "Mod+Ctrl+L".action.move-column-right = {};

      # # Workspaces
      # "Mod+1".action.focus-workspace = 1;
      # "Mod+2".action.focus-workspace = 2;
      # "Mod+3".action.focus-workspace = 3;
      # "Mod+4".action.focus-workspace = 4;
      # "Mod+5".action.focus-workspace = 5;
      # "Mod+6".action.focus-workspace = 6;
      # "Mod+7".action.focus-workspace = 7;
      # "Mod+8".action.focus-workspace = 8;
      # "Mod+9".action.focus-workspace = 9;
      # "Mod+0".action.focus-workspace = 10;

      # # Moving to workspaces
      # "Mod+Shift+1".action.move-column-to-workspace = 1;
      # "Mod+Shift+2".action.move-column-to-workspace = 2;
      # "Mod+Shift+3".action.move-column-to-workspace = 3;
      # "Mod+Shift+4".action.move-column-to-workspace = 4;
      # "Mod+Shift+5".action.move-column-to-workspace = 5;
      # "Mod+Shift+6".action.move-column-to-workspace = 6;
      # "Mod+Shift+7".action.move-column-to-workspace = 7;
      # "Mod+Shift+8".action.move-column-to-workspace = 8;
      # "Mod+Shift+9".action.move-column-to-workspace = 9;
      # "Mod+Shift+0".action.move-column-to-workspace = 10;

      # # Window management
      # "Mod+Q".action.close-window = {};
      # "Mod+F".action.maximize-column = {};
      # "Mod+Shift+F".action.fullscreen-window = {};
      # "Mod+A".action.open-overview = {};
      # "Mod+Alt+F".action.toggle-window-floating = {};

      # # Column width
      # "Mod+R".action.switch-preset-column-width = {};
      # "Mod+Shift+R".action.reset-window-height = {};

      # # Applications
      # "Mod+T".action.spawn = "ghostty";
      # # "Mod+T".action.spawn = "foot";
      # "Mod+D".action.spawn = ["rofi" "-show" "drun" "-config" "~/.config/rofi/config.rasi"];
      # # "Mod+D".action.spawn = noctalia "launcher toggle";
      # "Mod+Shift+D".action.spawn = ["rofi" "-show" "run" "-config" "~/.config/rofi/config.rasi"];
      # "Mod+E".action.spawn = "nautilus";
      # "Mod+Alt+V".action.spawn = "pavucontrol";

      # # Rofi utilities
      # "Mod+Shift+E".action.spawn = ["~/.local/bin/rofi-emoji"];
      # "Mod+Shift+V".action.spawn = ["~/.local/bin/rofi-clipboard"];

      # # Media keys
      # # "XF86AudioRaiseVolume".action.spawn = ["volume-control" "up"];
      # # "XF86AudioLowerVolume".action.spawn = ["volume-control" "down"];
      # # "XF86AudioMute".action.spawn = ["volume-control" "mute"];
      # "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
      # "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
      # "XF86AudioMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
      # "XF86MonBrightnessUp".action.spawn = ["brightnessctl" "set" "5%+"];
      # "XF86MonBrightnessDown".action.spawn = ["brightnessctl" "set" "5%-"];

      # # Screenshots
      # "Mod+Shift+S".action.screenshot = {};
      # "Mod+S".action.screenshot-screen = {};
      # "Mod+Alt+S".action.screenshot-window = {};

      # # System
      # "Mod+Shift+Q".action.quit = {};
      # "Mod+P".action.spawn = ["wlogout"];
      # # "Mod+P".action.spawn = noctalia "sessionMenu toggle";
      # "Mod+Shift+P".action.power-off-monitors = {};
      # # "Mod+Shift+L".action.spawn = noctalia "lockScreen lock";
      # "Mod+Shift+L".action.spawn = ["loginctl" "lock-session"];

      # # Clipboard (using cliphist via Rofi)
      # # "Mod+Shift+V".action.spawn = ["clipboard-manager" "show"];
      # # "Mod+Alt+C".action.spawn = ["clipboard-manager" "clear"];

      # # Scratchpad
      # "Mod+Shift+Minus".action.move-window-to-workspace = "scratchpad";
      # "Mod+Minus".action.focus-workspace = "scratchpad";
      # };
    };
  };
}

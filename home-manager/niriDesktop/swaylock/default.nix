{
  ...
}:

{
  home.file.".config/swaylock/config" = {
    text = ''
      # General Behavior & Appearance
      screenshots
      effect-blur=7x5
      effect-vignette=0.5:0.5
      font="SF Pro Display"
      fade= 0.1

      # Indicator & Clock
      indicator
      indicator-radius=100
      clock
      timestr=%I:%M
      datestr=%a, %B %d

      # Theme Colors (Example)
      ring-color=11111bff
      key-hl-color=a6e3a1ff
      text-color=cdd6f4ff

      # Default State
      inside-color=00000088

      # Verifying State (Inside stays same, Ring turns Blue)
      inside-ver-color=00000088
      ring-ver-color=0000ffff
      text-ver-color=0000ffff

      # Wrong State (Inside stays same, Ring turns Red)
      inside-wrong-color=00000088
      ring-wrong-color=ff0000ff
      text-wrong-color=ff0000ff

      # Clear State (Inside stays same, Ring turns Transparent/Clear)
      inside-clear-color=00000088
      ring-clear-color=11111bff
      text-clear-color=ffffffff

      # Font Sizes
      font-size=38
      clock-font-size=60
      date-font-size=30
    '';
  };
}

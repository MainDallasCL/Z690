{
  inputs,
  ...
}:
{
  imports = [ inputs.nixarchy.nixosModules.nixarchy ];
  programs.nixarchy.enable = true;
  # ly already greets; nixarchy's SDDM would be a second one.
  # Your greeter picks up the "Omarchy" session from wayland-sessions.
  programs.nixarchy.displayManager = false;
  home-manager.users.dallas = {
    imports = [ inputs.nixarchy.homeManagerModules.nixarchy ];
    programs.nixarchy.enable = true;
  };
}

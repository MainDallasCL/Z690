{
  inputs,
  ...
}:
{
  imports = [ inputs.nixarchy.nixosModules.nixarchy ];
  programs.nixarchy.enable = true;
  # ly already greets; nixarchy's SDDM would be a second one.
  # Your greeter picks up the "Omarchy" session from wayland-sessions.

  # nixos-hardware's laptop profile (via asus-zephyrus-gu603h) and nixarchy
  # each mkDefault one of these from the other -> infinite recursion.
  # Pin both so neither default is ever evaluated.
  services.tlp.enable = false;
  services.power-profiles-daemon.enable = true;

  programs.nixarchy.displayManager = false;
  home-manager.users.dallas = {
    imports = [ inputs.nixarchy.homeManagerModules.nixarchy ];
    programs.nixarchy.enable = true;
  };
}

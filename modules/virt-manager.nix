{
  pkgs, ...
}:{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  environment.systemPackages = with pkgs; [
    dnsmasq
    looking-glass-client
  ];
  networking.firewall.trustedInterfaces = [ "virbr0" ];
}

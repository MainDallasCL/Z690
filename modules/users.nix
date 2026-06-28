{
  inputs, lib, config, pkgs, ...
}:{
  users.users = {
    dallas = {
      description = "dallas";
      isNormalUser = true;
      #openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      #];
      extraGroups = ["wheel" "networkmanager" "audio" "i2c" "kvm" "libvirtd"];
      packages = with pkgs; [
        thunderbird
        btop
        fish
      ];
      shell = pkgs.fish;
    };
  };
}

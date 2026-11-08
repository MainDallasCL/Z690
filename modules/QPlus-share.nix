{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.sshfs ];

  # Lets non-root users access the mount when allow_other is used
  programs.fuse.userAllowOther = true;

  # System-wide ssh config: applies to root (which runs the mount) as well as you
  programs.ssh.extraConfig = ''
    Host QPlus
      HostName 192.168.2.175
      User dallas
      IdentityFile /home/dallas/.ssh/QPlus
      IdentitiesOnly yes
      StrictHostKeyChecking accept-new
  '';

  fileSystems."/mnt/QPlus" = {
    device = "QPlus:/mnt/MEDIA";
    fsType = "sshfs";
    options = [
      "nodev"
      "noatime"
      "reconnect"
      "ServerAliveInterval=15"
      "ServerAliveCountMax=3"
      "allow_other"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
      "noauto"
      "_netdev"
    ];
  };
}

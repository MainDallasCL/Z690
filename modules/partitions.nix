{
  inputs, lib, config, pkgs, ...
}:{
  fileSystems."/" = {
      fsType = "f2fs";
      options = [
        "compress_algorithm=zstd:6"
        "compress_chksum"
        "atgc,gc_merge"
        "lazytime"
      ];
    };
    
    fileSystems."/boot" = {
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
    
    fileSystems."/mnt/EXTRA" =
    { device = "/dev/disk/by-label/EXTRA";
      fsType = "f2fs";
      options = [
        "compress_algorithm=zstd:6"
        "compress_chksum"
        "atgc,gc_merge"
        "lazytime"
      ];
    };

    fileSystems."/mnt/nvRAID" =
    { device = "/dev/disk/by-label/nvRAID";
      fsType = "f2fs";
      options = [
        "compress_algorithm=zstd:6"
        "compress_chksum"
        "atgc,gc_merge"
        "lazytime"
      ];
    };

    fileSystems."/mnt/RAID" =
    { device = "/dev/disk/by-label/SSDRAID";
      fsType = "ext4";
    };
}

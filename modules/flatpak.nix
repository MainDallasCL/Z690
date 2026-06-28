{
  inputs, lib, config, pkgs, ...
}: {
  services.flatpak.enable = true;

  services.flatpak.remotes = lib.mkOptionDefault [
    {
      name = "hero-persson";
      location = "https://hero-persson.github.io/unmojang-flatpak/index.flatpakrepo";
    }
    {
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }
  ];

  services.flatpak.packages = [
    { appId = "org.unmojang.FjordLauncher"; origin = "hero-persson";  }
    { appId = "org.kde.Platform/x86_64/6.10"; origin = "flathub";  }
    { appId = "com.github.tchx84.Flatseal"; origin = "flathub";  }
  ];

services.flatpak.overrides = {
  "org.unmojang.FjordLauncher" = {
    Context = {
      filesystems = [ "/mnt/RAID/SHARED/JavaDepot/:ro" ];
    };
  };
};

}

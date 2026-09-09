{ stdenv, lib, ... }:

stdenv.mkDerivation rec {
  pname = "linux-armbian-tanix-tx6";
version = "7.2.3";
modDirVersion = "7.2.3-edge-sunxi64";

  # Kept up to date automatically by nixos-rebuild itself — see
  # nixos-rebuild-wrapper.nix / armbian-kernel-update.sh.
  src = /boot/armbian-kernel-src;

  outputs = [ "out" "dev" ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    mkdir -p $out
    cp ${src}/boot/vmlinuz-${modDirVersion} $out/Image

    mkdir -p $out/dtbs
    cp -r ${src}/boot/dtb-${modDirVersion}/allwinner $out/dtbs/allwinner

    mkdir -p $out/lib/modules/${modDirVersion}
    cp -r ${src}/lib/modules/${modDirVersion}/kernel $out/lib/modules/${modDirVersion}/kernel
    cp ${src}/lib/modules/${modDirVersion}/modules.* $out/lib/modules/${modDirVersion}/

    # Headers (from linux-headers-*-sunxi64), for building out-of-tree
    # modules / DKMS against this kernel. Debian's headers package installs
    # to /usr/src/linux-headers-<version>/ — copy that in as the standard
    # nixpkgs kernel.dev "build" tree, with "source" symlinked to it.
    mkdir -p $dev/lib/modules/${modDirVersion}
    headers_src="$(find ${src}/usr/src -maxdepth 1 -type d -name 'linux-headers-*')"
    cp -r "$headers_src" $dev/lib/modules/${modDirVersion}/build
    ln -s ./build $dev/lib/modules/${modDirVersion}/source

    # UAPI/libc headers (from linux-libc-dev-*-sunxi64), used by userspace
    # code that includes kernel headers directly.
    mkdir -p $dev/include
    cp -r ${src}/usr/include/. $dev/include/
  '';

  configfile = "${src}/boot/config-${modDirVersion}";

  passthru = {
    inherit modDirVersion;
    kernelOlder = lib.versionOlder version;
    kernelAtLeast = lib.versionAtLeast version;
    features = { };
  };

  meta.platforms = [ "aarch64-linux" ];
}

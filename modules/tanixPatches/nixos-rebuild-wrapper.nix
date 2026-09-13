final: prev:
let
  updateScript = prev.writeShellScript "armbian-kernel-update" (
    builtins.readFile ./armbian-kernel-update.sh
  );
in
{
  nixos-rebuild-ng = prev.nixos-rebuild-ng.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.makeWrapper ];
    postFixup = (old.postFixup or "") + ''
      wrapProgram $out/bin/nixos-rebuild \
        --prefix PATH : ${
          prev.lib.makeBinPath [
            prev.curl
            prev.gzip
            prev.gnused
            prev.gawk
            prev.dpkg
            prev.coreutils
            prev.findutils
          ]
        } \
        --run '${updateScript} || echo "[armbian-kernel-update] check failed, continuing without update" >&2'
    '';
  });
}

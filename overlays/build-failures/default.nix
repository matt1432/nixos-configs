final: prev: {
  # FIXME: dmd doesn't build on latest nixos-unstable. make issue?
  dmd = prev.dmd.overrideAttrs (o: {
    postPatch =
      o.postPatch
      + ''
        rm dmd/compiler/test/fail_compilation/needspkgmod.d
      '';
  });

  # FIXME: get rid of these once inputs don't need them
  utillinux = prev.util-linux;
  noto-fonts-cjk = prev.noto-fonts-cjk-sans;
}

final: prev: {
  # FIXME: dmd doesn't build on latest nixos-unstable. make issue?
  dmd = prev.dmd.overrideAttrs (o: {
    postPatch =
      o.postPatch
      + ''
        rm dmd/compiler/test/fail_compilation/needspkgmod.d
      '';
  });
}

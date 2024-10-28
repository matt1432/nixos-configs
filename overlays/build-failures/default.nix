final: prev: {
  # FIXME: https://pr-tracker.nelim.org/?pr=351090
  dmd = prev.dmd.overrideAttrs (o: {
    postPatch = ''
      ${o.postPatch}

      substituteInPlace dmd/compiler/test/fail_compilation/needspkgmod.d \
          --replace-fail 'REQUIRED_ARGS: -Icompilable' 'REQUIRED_ARGS: -Icompilable -L--no-demangle'
    '';
  });
}

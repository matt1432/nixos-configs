final: prev: {
  wyoming-faster-whisper = prev.wyoming-faster-whisper.override {
    python3Packages =
      (final.python3.override {
        packageOverrides = pyFinal: pyPrev: {
          torch = pyFinal.torch-bin;
        };
      }).pkgs;
  };

  # FIXME: https://github.com/NixOS/nixpkgs/issues/513245
  openldap = prev.openldap.overrideAttrs {
    doCheck = !prev.stdenv.hostPlatform.isi686;
  };
}

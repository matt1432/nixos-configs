final: prev: {
  wyoming-faster-whisper = prev.wyoming-faster-whisper.override {
    python3Packages =
      (final.python3.override {
        packageOverrides = pyFinal: pyPrev: {
          torch = pyFinal.torch-bin;
        };
      }).pkgs;
  };

  # FIXME: https://nixpkgs-tracker.ocfox.me/?pr=493376
  pythonPackagesExtensions =
    prev.pythonPackagesExtensions
    ++ [
      (python-final: python-prev: {
        picosvg = python-prev.picosvg.overridePythonAttrs (oldAttrs: {
          doCheck = false;
        });
      })
    ];
}

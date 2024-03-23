final: prev: {
  # FIXME: https://github.com/NixOS/nixpkgs/issues/298150
  fprintd = prev.fprintd.overrideAttrs (_: {
    mesonCheckFlags = [
      "--no-suite"
      "fprintd:TestPamFprintd"
    ];
  });
}

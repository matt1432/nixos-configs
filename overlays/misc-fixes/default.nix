final: prev: let
  inherit (final) config stdenv;
  inherit (final.lib) cmakeBool cmakeFeature getBin optionals;
in {
  # NOTE: https://github.com/NixOS/nixpkgs/pull/549747
  frei0r = prev.frei0r.overrideAttrs (o: {
    nativeBuildInputs =
      o.nativeBuildInputs
      ++ optionals config.cudaSupport [
        final.cudaPackages.cuda_nvcc
      ];

    buildInputs =
      o.buildInputs
      ++ optionals stdenv.hostPlatform.isLinux [
        final.gavl
      ];

    cmakeFlags =
      [
        (cmakeBool "WITHOUT_GAVL" (!stdenv.hostPlatform.isLinux))
      ]
      ++ optionals config.cudaSupport [
        (cmakeFeature "CUDAToolkit_ROOT" "${getBin final.cudaPackages.cuda_nvcc}")
      ];
  });
}

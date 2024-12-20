{
  lib,
  fetchFromGitHub,
  onnxruntime,
  python3Packages,
  wyoming-openwakeword,
  ...
}: let
  inherit (lib) makeLibraryPath;
in
  wyoming-openwakeword.overridePythonAttrs (o: {
    version = o.version + "-vad";

    # https://github.com/rhasspy/wyoming-openwakeword/pull/17
    src = fetchFromGitHub {
      owner = "rhasspy";
      repo = "wyoming-openwakeword";
      rev = "8e679a592f5862d67a7b688d3f711b468e4b1f93";
      hash = "sha256-sP0i2ghcTpuuZbVTsAFw527y2oaJIH9OolQtKjkYC2E=";
    };

    buildInputs =
      (o.buildInputs or [])
      ++ [onnxruntime];

    propagatedBuildInputs =
      (o.propagatedBuildInputs or [])
      ++ [python3Packages.onnxruntime];

    # Native onnxruntime lib used by Python module onnxruntime can't find its other libs without this
    makeWrapperArgs = [
      ''--prefix LD_LIBRARY_PATH : "${makeLibraryPath [onnxruntime]}"''
    ];

    postFixup = ''
      cp -ar ./wyoming_openwakeword/models/silero_vad.onnx $out/lib/python*/site-packages/wyoming_openwakeword/models
    '';
  })

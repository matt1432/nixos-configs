{
  lib,
  fetchFromGitHub,
  onnxruntime,
  python3Packages,
  ...
}: let
  inherit (lib) makeLibraryPath;
in
  python3Packages.buildPythonApplication rec {
    pname = "wyoming-openwakeword";
    version = "1.10.0-vad";
    pyproject = true;

    # https://github.com/rhasspy/wyoming-openwakeword/pull/17
    src = fetchFromGitHub {
      owner = "rhasspy";
      repo = "wyoming-openwakeword";
      rev = "8e679a592f5862d67a7b688d3f711b468e4b1f93";
      hash = "sha256-sP0i2ghcTpuuZbVTsAFw527y2oaJIH9OolQtKjkYC2E=";
    };

    build-system = with python3Packages; [
      setuptools
    ];
    buildInputs = [onnxruntime];

    pythonRelaxDeps = [
      "wyoming"
    ];

    pythonRemoveDeps = [
      "tflite-runtime-nightly"
    ];

    dependencies = with python3Packages; [
      tensorflow-bin
      wyoming
    ];

    propagatedBuildInputs = [python3Packages.onnxruntime];

    pythonImportsCheck = [
      "wyoming_openwakeword"
    ];

    # Native onnxruntime lib used by Python module onnxruntime can't find its other libs without this
    makeWrapperArgs = [
      ''--prefix LD_LIBRARY_PATH : "${makeLibraryPath [onnxruntime]}"''
    ];

    postFixup = ''
      cp -ar ./wyoming_openwakeword/models/silero_vad.onnx $out/lib/python*/site-packages/wyoming_openwakeword/models
    '';

    meta = {
      changelog = "https://github.com/rhasspy/wyoming-openwakeword/blob/v${version}/CHANGELOG.md";
      description = "Open source voice assistant toolkit for many human languages";
      homepage = "https://github.com/rhasspy/wyoming-openwakeword";
      license = lib.licenses.mit;
      mainProgram = "wyoming-openwakeword";
    };
  }

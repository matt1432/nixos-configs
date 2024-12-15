/*
This package uses a `wyoming-openwakeword` fork that makes use of
the upstream `openwakeword` instead of a fork: https://github.com/rhasspy/wyoming-openwakeword/pull/27
*/
{
  fetchFromGitHub,
  lib,
  openwakeword,
  python3Packages,
  ...
}: let
  inherit (lib) attrValues;
in
  python3Packages.buildPythonApplication {
    pname = "wyoming-openwakeword";
    version = "1.10.0-unstable";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "rhasspy";
      repo = "wyoming-openwakeword";
      # rev = "synesthesiam-20240627-openwakeword";
      rev = "324d669645a778439c5392d9e287a763ead3cf4c";
      hash = "sha256-69oR2LHiUfx8j39nWp7XhG5xTvmOoPCLjSlH1CFvavo=";
    };

    nativeBuildInputs = attrValues {
      inherit
        (python3Packages)
        setuptools
        ;
    };

    pythonRelaxDeps = [
      "wyoming"
    ];

    propagatedBuildInputs = attrValues {
      inherit
        (python3Packages)
        wyoming
        ;

      inherit openwakeword;
    };

    pythonImportsCheck = [
      "wyoming_openwakeword"
    ];

    meta = {
      description = "Open source voice assistant toolkit for many human languages";
      homepage = "https://github.com/rhasspy/wyoming-openwakeword";
      license = lib.licenses.mit;
      mainProgram = "wyoming-openwakeword";
    };
  }

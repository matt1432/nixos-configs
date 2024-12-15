{
  fetchFromGitHub,
  python3Packages,
  speexdsp-ns,
  tflite-runtime,
  ...
}: let
  inherit (builtins) attrValues;
in
  python3Packages.buildPythonApplication rec {
    pname = "openwakeword";
    version = "0.6.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "dscripka";
      repo = "openWakeWord";
      rev = "v${version}";
      hash = "sha256-QsXV9REAHdP0Y0fVZuU+Gt9+gcPMB60bc3DOMDYuaDM=";
    };

    nativeBuildInputs = with python3Packages; [
      setuptools
    ];

    propagatedBuildInputs = attrValues {
      inherit
        (python3Packages)
        onnxruntime
        tqdm
        scipy
        scikit-learn
        requests
        ;

      inherit
        speexdsp-ns
        tflite-runtime
        ;
    };
  }

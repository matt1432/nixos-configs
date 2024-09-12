{
  fetchFromGitHub,
  fetchpatch,
  python3Packages,
  speexdsp-ns,
  ...
}:
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

  # Patch upstream to enable use of full tensorflow dep
  pythonRemoveDeps = ["tflite-runtime"];
  patches = [
    (fetchpatch {
      url = "https://github.com/dscripka/openWakeWord/pull/178/commits/99cd87e8898348255e864540e43bab17ce0576d6.patch";
      hash = "sha256-xveMBZTcYfT8LKiiStqYjjOdUOM/v4taQzSewo97Bfc=";
    })
  ];

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs =
    (with python3Packages; [
      onnxruntime
      tensorflow-bin
      tqdm
      scipy
      scikit-learn
      requests
    ])
    ++ [speexdsp-ns];
}

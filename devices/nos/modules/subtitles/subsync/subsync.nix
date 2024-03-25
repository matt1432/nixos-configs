{
  fetchFromGitHub,
  ffmpeg,
  pkg-config,
  pocketsphinx,
  python3Packages,
  sphinxbase,
  ...
}: let
  inherit (builtins) concatStringsSep;
in
python3Packages.buildPythonPackage {
  pname = "subsync";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "sc0ty";
    repo = "subsync";
    rev = "8e0cf71960b9a5418acb60a1910cf3295d67e6bf";
    hash = "sha256-jUur1U1yNShQx70/mj36+sGoVk8+E5hQUV/G79q2A2k=";
  };

  buildInputs = [
    ffmpeg
    pkg-config
    pocketsphinx
    sphinxbase
  ];

  nativeBuildInputs = with python3Packages; [
    pip
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3Packages; [
    certifi
    cryptography
    pybind11
    pycryptodome
    pysubs2
    pyyaml
    requests
    utils
  ];

  patches = [
    ./patches/cmd_ln.patch
    ./patches/cstdint.patch
  ];

  # The tests are for the GUI
  doCheck = false;

  # 'pip install .' takes care of building the package
  buildPhase = "";

  installPhase = ''
    python -m pip install . ${concatStringsSep " " [
      "--no-index"
      "--no-warn-script-location"
      "--prefix=\"$out\""
      "--no-cache"
    ]}
  '';
}

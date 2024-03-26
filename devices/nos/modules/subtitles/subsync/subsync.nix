{
  ffmpeg,
  pkg-config,
  pocketsphinx,
  python3Packages,
  sphinxbase,
  subsync-src,
  ...
}: let
  inherit (builtins) concatStringsSep;
in
python3Packages.buildPythonPackage {
  pname = "subsync";
  version = subsync-src.shortRev;

  src = subsync-src;

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

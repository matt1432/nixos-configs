{
  autoreconfHook,
  fetchFromGitHub,
  pkg-config,
  python3,
  sphinxbase,
  stdenv,
  swig2,
  ...
}:
stdenv.mkDerivation {
  pname = "pocketsphinx";
  version = "5prealpha";

  src = fetchFromGitHub {
    owner = "cmusphinx";
    repo = "pocketsphinx";
    rev = "5da71f0a05350c923676b02a69423d1291825d5b";
    hash = "sha256-YZwuVYg8Uqt1gOYXeYC8laRj+IObbuO9f/BjcQKRwkY=";
  };

  patches = [./patches/distutils.patch];

  autoreconfPhase = ''
    ./autogen.sh
  '';
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    swig2
    python3
  ];
  propagatedBuildInputs = [
    sphinxbase
  ];

  postFixup = ''
    cp $out/include/pocketsphinx/* $out/include
  '';
}

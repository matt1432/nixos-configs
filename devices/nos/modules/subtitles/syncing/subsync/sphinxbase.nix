{
  autoreconfHook,
  bison,
  fetchFromGitHub,
  pkg-config,
  python3,
  stdenv,
  swig2,
  ...
}:
stdenv.mkDerivation {
  name = "sphinxbase";
  version = "5prealpha"; # Deprecated

  buildInputs = [bison pkg-config python3 swig2];
  nativeBuildInputs = [autoreconfHook];

  autoreconfPhase = ''
    ./autogen.sh
  '';

  src = fetchFromGitHub {
    owner = "cmusphinx";
    repo = "sphinxbase";
    rev = "617e53691889336a482631380f75b453445d0dae";
    hash = "sha256-w/Huz4+crTzdiSyQVAx0h3lhtTTrtPyKp3xpQD5EG9g=";
  };
}

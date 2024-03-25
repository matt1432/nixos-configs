{
  cmake,
  fetchFromGitHub,
  pkg-config,
  sphinxbase,
  stdenv,
  ...
}:
stdenv.mkDerivation rec {
  name = "pocketsphinx";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "cmusphinx";
    repo = "pocketsphinx";
    rev = "7be89aae3e76568e02e4f3d41cf1adcb7654430c";
    hash = "sha256-imrwUIpORpfInitVjU11SKPPpjvObKyfI8IB4f41hfY=";
  };

  buildInputs = [pkg-config];
  nativeBuildInputs = [cmake sphinxbase];

  postFixup = ''
    cp -ar ${src}/src/util $out/include
  '';
}

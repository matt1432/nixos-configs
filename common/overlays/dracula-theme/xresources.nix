{
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation {
  name = "dracula-xresources";

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "xresources";
    rev = "539ef24e9b0c5498a82d59bfa2bad9b618d832a3";
    sha256 = "sha256-6fltsAluqOqYIh2NX0I/LC3WCWkb9Fn8PH6LNLBQbrY=";
  };

  installPhase = ''
    mkdir -p $out/xres
    cp -a ./Xresources $out/xres/
  '';
}

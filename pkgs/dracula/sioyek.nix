{
  sioyek-theme-src,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  pname = "dracula-sioyek";
  version = sioyek-theme-src.shortRev;

  src = sioyek-theme-src;

  installPhase = ''
    cat ./dracula.config > $out
  '';
}

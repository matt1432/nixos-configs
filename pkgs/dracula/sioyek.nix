{
  mkVersion,
  sioyek-theme-src,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  pname = "dracula-sioyek";
  version = mkVersion sioyek-theme-src;

  src = sioyek-theme-src;

  installPhase = ''
    cat ./dracula.config > $out
  '';
}

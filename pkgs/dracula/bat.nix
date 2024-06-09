{
  bat-theme-src,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  pname = "dracula-bat";
  version = bat-theme-src.shortRev;

  src = bat-theme-src;

  installPhase = ''
    cat ./Dracula.tmTheme > $out
  '';
}

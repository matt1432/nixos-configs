{
  bat-theme-src,
  mkVersion,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  pname = "dracula-bat";
  version = mkVersion bat-theme-src;

  src = bat-theme-src;

  installPhase = ''
    cat ./Dracula.tmTheme > $out
  '';
}

{
  xresources-src,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  pname = "dracula-xresources";
  version = xresources-src.shortRev;

  src = xresources-src;

  installPhase = ''
    cat ./Xresources > $out
  '';
}

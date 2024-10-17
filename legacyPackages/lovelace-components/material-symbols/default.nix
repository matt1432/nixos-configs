{
  material-symbols-src,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  pname = "material-symbols";
  version = "0.0.0+${material-symbols-src.shortRev}";
  src = material-symbols-src;
  phases = ["installPhase"];
  installPhase = ''
    mkdir $out
    cp $src/dist/material-symbols.js $out
  '';
}

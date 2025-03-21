{
  stdenv,
  dart-sass,
  ...
}:
stdenv.mkDerivation {
  pname = "custom-css";
  version = "0.0.0";

  src = ./.;

  nativeBuildInputs = [dart-sass];

  buildPhase = ''
    sass ./style.scss ./style.css
  '';

  installPhase = ''
    cp -rf ./style.css $out
  '';
}

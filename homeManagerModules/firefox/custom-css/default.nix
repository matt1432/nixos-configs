{
  stdenv,
  dart-sass,
  firefox-gx,
  rounding,
  ...
}:
stdenv.mkDerivation {
  pname = "custom-css";
  inherit (firefox-gx) version;

  src = ./.;

  nativeBuildInputs = [dart-sass];

  buildPhase = ''
    substituteInPlace ./style.scss --replace-fail \
        '$rounding' '${toString rounding}px'

    sass ./style.scss ./style.css
  '';

  installPhase = ''
    cp -rf ./style.css $out
  '';
}

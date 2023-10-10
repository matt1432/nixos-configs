{ lib, stdenvNoCC, fetchFromGitHub }:
let
  pname = "firefox-gx";
  version = "8.4";
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "Godiesc";
    repo = pname;
    rev = "v.${version}";
    sha256 = "sha256-Izb2dLIThLAXJ+Z6fNyRli3v3kV1upyDY0wA2VNVi+o=";
  };

  installPhase = ''
    # Personal changes
    sed -i 's/var(--fuchsia))/var(--purple))/' ./chrome/components/ogx_root-personal.css

    mv ./Extras/Tab-Shapes/ogx_tab-shapes.css ./chrome/components
    rm ./user.js
    mv ./Extras/Tab-Shapes/user.js ./
    sed -i 's/rounded_corner.chrome",        true/rounded_corner.chrome",        false/' ./user.js
    sed -i 's/rounded_corner.wave",          false/rounded_corner.wave",          true/' ./user.js

    mv ./Extras/Left-SideBar/ogx_left-sidebar.css ./chrome/components
    mv ./Extras/OneLine/ogx_oneline.css ./chrome/components

    mkdir -p $out
    cp -r ./* $out
  '';

  meta = with lib; {
    description = "Firefox Theme CSS to Opera GX Lovers ";
    homepage = "https://github.com/Godiesc/firefox-gx";
    license = licenses.mspl;
  };
}

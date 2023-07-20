### test package
{ lib
, stdenv
, fetchFromGitHub
, pkgs
}:

let

wallpaper = fetchFromGitHub {
    repo = "wallpaper";
    owner = "dracula";
    rev = "3bd5b95d4ae08d2adfb2931e090bb657fd9a6a4f";
    hash = "sha256-3p7PCMZHIytkOH3BBUMqaYBFcrSef3YHthyJY6KDArg=";
  };

in

stdenv.mkDerivation {
  name = "utterly-sddm";
  version = "unstable-2022-11-06";

  src = fetchFromGitHub {
    repo = "Utterly-Sweet-Plasma";
    owner = "HimDek";
    rev = "4bb007e865d559de8dd43bbffb93778ea136f957";
    hash = "sha256-oEyf6FI5XSjXPZjzBiGypwZY89ulhwAwk9QIJ3pMw/M=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    rm ./sddm/background.jpg
    cp ${wallpaper}/first-collection/nixos.png ./sddm/background.jpg

    mkdir -p $out/share/sddm/themes/Utterly-Sweet
    mv ./sddm/* $out/share/sddm/themes/Utterly-Sweet

    runHook postInstall
  '';

  meta = with lib; {
    description = "A dark theme for SDDM";
    homepage = "https://github.com/dracula/gtk";
    maintainers = with maintainers; [ matt1432 ];
    platforms = platforms.all;
  };
}

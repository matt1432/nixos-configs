{
  # nix build inputs
  lib,
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  name = "dracula-wallpaper.png";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/aynp/dracula-wallpapers/main/Art/4k/Waves%201.png";
    hash = "sha256-f9FwSOSvqTeDj4bOjYUQ6TM+/carCD9o5dhg/MnP/lk=";
  };

  phases = ["installPhase"];

  installPhase = ''
    cp -a $src $out
  '';

  meta = {
    license = lib.licenses.cc-by-sa-40;
    homepage = "https://github.com/aynp/dracula-wallpapers";
    description = ''
      Wallpaper based on the Dracula Theme.
    '';
  };
}

{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  name = "dracula-wallpaper";

  src = fetchurl {
    url = "https://github.com/aynp/dracula-wallpapers/blob/main/Art/4k/Waves%201.png?raw=true";
    hash = "sha256-f9FwSOSvqTeDj4bOjYUQ6TM+/carCD9o5dhg/MnP/lk=";
  };

  phases = ["installPhase"];

  installPhase = ''
    mv ./* ./waves.png
    mkdir -p $out/wallpapers
    cp -a ./waves.png $out/wallpapers
  '';
}

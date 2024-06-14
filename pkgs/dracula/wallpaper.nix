{
  fetchurl,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  pname = "dracula-wallpaper";
  version = "";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/aynp/dracula-wallpapers/main/Art/4k/Waves%201.png";
    hash = "sha256-f9FwSOSvqTeDj4bOjYUQ6TM+/carCD9o5dhg/MnP/lk=";
  };

  phases = ["installPhase"];

  installPhase = ''
    cp $src $out
  '';
}

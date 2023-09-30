### test package
{ stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  name = "lavanda-kde";
  version = "unstable-2022-08-24";

  src = fetchFromGitHub {
    repo = "Lavanda-kde";
    owner = "vinceliuice";
    rev = "f247e5c0078df64fdee2c74d27baf479f025001e";
    hash = "sha256-hLP4Ye3lRKSCk9I+PguAWhlHUDvIqRlRazXyOccPerQ=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/sddm/themes/
    mv ./sddm/* $out/share/sddm/themes/

    runHook postInstall
  '';
}

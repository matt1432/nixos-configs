{ lib
, stdenv
, fetchFromGitHub
, pkgs
}:

stdenv.mkDerivation {
  name = "dracula-plymouth";
  version = "unstable-2023-01-13";

  src = fetchFromGitHub {
    repo = "plymouth";
    owner = "dracula";
    rev = "37aa09b27ecee4a825b43d2c1d20b502e8f19c96";
    hash = "sha256-7YwkBzkAND9lfH2ewuwna1zUkQStBBx4JHGw3/+svhA=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plymouth/themes
    mv ./dracula $out/share/plymouth/themes/

    sed -i "s@\/usr\/@$out\/@" $out/share/plymouth/themes/dracula/dracula.plymouth

    runHook postInstall
  '';

  meta = with lib; {
    description = "A dark theme for Plymouth";
    homepage = "https://github.com/dracula/plymouth/tree/main";
    license = licenses.mit;
    maintainers = with maintainers; [ matt1432 ];
    platforms = platforms.all;
  };
}

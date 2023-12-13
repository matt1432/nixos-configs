{
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation {
  name = "dracula-plymouth";

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "plymouth";
    rev = "37aa09b27ecee4a825b43d2c1d20b502e8f19c96";
    hash = "sha256-7YwkBzkAND9lfH2ewuwna1zUkQStBBx4JHGw3/+svhA=";
  };

  installPhase = let
    dracula-script = ./dracula-plymouth.patch;
  in ''
    chmod 777 ./dracula

    rm ./dracula/dracula.script
    cp -a ${dracula-script} ./dracula/dracula.script

    sed -i "s@\/usr\/@$out\/@" ./dracula/dracula.plymouth

    mkdir -p $out/share/plymouth/themes
    cp -a ./dracula $out/share/plymouth/themes/
  '';
}

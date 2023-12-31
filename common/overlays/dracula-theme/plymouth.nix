{
  stdenv,
  plymouth-theme-src,
  ...
}:
stdenv.mkDerivation {
  name = "dracula-plymouth";
  version = plymouth-theme-src.rev;

  src = plymouth-theme-src;

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

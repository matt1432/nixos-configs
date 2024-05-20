{
  stdenv,
  dracula-plymouth-src,
  ...
}:
stdenv.mkDerivation {
  name = "dracula-plymouth";
  version = dracula-plymouth-src.shortRev;

  src = dracula-plymouth-src;

  installPhase = ''
    chmod 777 ./dracula

    sed -i "s@\/usr\/@$out\/@" ./dracula/dracula.plymouth

    mkdir -p $out/share/plymouth/themes
    cp -a ./dracula $out/share/plymouth/themes/
  '';
}

{
  stdenv,
  plymouth-theme-src,
  ...
}:
stdenv.mkDerivation {
  name = "dracula-plymouth";
  version = plymouth-theme-src.shortRev;

  src = plymouth-theme-src;

  installPhase = ''
    chmod 777 ./dracula

    sed -i "s@\/usr\/@$out\/@" ./dracula/dracula.plymouth

    mkdir -p $out/share/plymouth/themes
    cp -a ./dracula $out/share/plymouth/themes/
  '';
}

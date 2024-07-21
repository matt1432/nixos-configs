{
  stdenv,
  dracula-plymouth-src,
  mkVersion,
  ...
}:
stdenv.mkDerivation {
  pname = "dracula-plymouth";
  version = mkVersion dracula-plymouth-src;

  src = dracula-plymouth-src;

  installPhase = ''
    chmod 777 ./dracula

    sed -i "s@\/usr\/@$out\/@" ./dracula/dracula.plymouth

    mkdir -p $out/share/plymouth/themes
    cp -a ./dracula $out/share/plymouth/themes/
  '';
}

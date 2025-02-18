{
  # nix build inputs
  lib,
  stdenv,
  mkVersion,
  dracula-plymouth-src,
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

  meta = {
    license = lib.licenses.mit;
    homepage = "https://github.com/matt1432/dracula-plymouth";
    description = ''
      Dark theme for Plymouth. Forked by me to add a password prompt and
      black background for more seemless boot sequence.
    '';
  };
}

{
  # nix build inputs
  lib,
  stdenv,
  mkVersion,
  sioyek-theme-src,
  ...
}:
stdenv.mkDerivation {
  pname = "dracula-sioyek";
  version = mkVersion sioyek-theme-src;

  src = sioyek-theme-src;

  installPhase = ''
    cat ./dracula.config > $out
  '';

  meta = {
    license = lib.licenses.mit;
    homepage = "https://github.com/dracula/sioyek";
    description = ''
      Dark theme for Sioyek.
    '';
  };
}

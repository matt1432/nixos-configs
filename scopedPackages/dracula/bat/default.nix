{
  # nix build inputs
  lib,
  stdenv,
  mkVersion,
  bat-theme-src,
  ...
}:
stdenv.mkDerivation {
  pname = "dracula-bat";
  version = mkVersion bat-theme-src;

  src = bat-theme-src;

  installPhase = ''
    cat ./Dracula.tmTheme > $out
  '';

  meta = {
    license = lib.licenses.mit;
    homepage = "https://github.com/matt1432/bat";
    description = ''
      Dark theme for bat based on the Dracula Sublime theme.
    '';
  };
}

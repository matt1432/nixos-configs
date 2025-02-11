{
  # nix build inputs
  lib,
  mkVersion,
  stdenv,
  protonhax-src,
  ...
}:
stdenv.mkDerivation {
  pname = "protonhax";
  version = mkVersion protonhax-src;

  src = protonhax-src;

  installPhase = ''
    install -Dt $out/bin -m755 protonhax
  '';

  meta = {
    license = with lib.licenses; [bsd3];
    homepage = "https://github.com/jcnils/protonhax";
    description = ''
      Tool to help running other programs (i.e. Cheat Engine) inside Steam's proton.
    '';
  };
}

{
  lib,
  mkVersion,
  protonhax-src,
  stdenv,
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
    description = "Tool to help running other programs (i.e. Cheat Engine) inside Steam's proton.";
    homepage = "https://github.com/jcnils/protonhax";
    license = with lib.licenses; [bsd3];
  };
}

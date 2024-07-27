{
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
}

{
  mkVersion,
  piper,
  piper-src,
  ...
}:
piper.overrideAttrs {
  pname = "piper";
  version = mkVersion piper-src;
  src = piper-src;

  mesonFlags = [
    "-Druntime-dependency-checks=false"
  ];
}

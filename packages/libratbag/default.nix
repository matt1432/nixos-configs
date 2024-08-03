{
  libratbag,
  libratbag-src,
  mkVersion,
  ...
}:
libratbag.overrideAttrs {
  pname = "libratbag";
  version = mkVersion libratbag-src;
  src = libratbag-src;
}

{
  buildLua,
  mkVersion,
  mpv-persist-properties-src,
  ...
}:
buildLua {
  pname = "persist-properties";
  version = mkVersion mpv-persist-properties-src;

  src = mpv-persist-properties-src;
}

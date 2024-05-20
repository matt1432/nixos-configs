{
  mpv-persist-properties-src,
  buildLua,
  ...
}:
buildLua {
  pname = "persist-properties";
  version = mpv-persist-properties-src.shortRev;

  src = mpv-persist-properties-src;
}

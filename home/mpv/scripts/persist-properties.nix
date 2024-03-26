{
  persist-properties-src,
  buildLua,
  ...
}:
buildLua {
  pname = "persist-properties";
  version = persist-properties-src.shortRev;

  src = persist-properties-src;
}

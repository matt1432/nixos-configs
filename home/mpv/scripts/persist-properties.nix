{
  persist-properties-src,
  buildLua,
  ...
}:
buildLua {
  pname = "persist-properties";
  version = persist-properties-src.rev;

  src = persist-properties-src;
}

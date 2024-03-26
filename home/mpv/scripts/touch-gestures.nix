{
  touch-gestures-src,
  buildLua,
  ...
}:
buildLua {
  pname = "touch-gestures";
  version = touch-gestures-src.shortRev;

  src = touch-gestures-src;
}

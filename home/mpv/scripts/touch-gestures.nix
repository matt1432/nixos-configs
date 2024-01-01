{
  touch-gestures-src,
  buildLua,
  ...
}:
buildLua {
  pname = "touch-gestures";
  version = touch-gestures-src.rev;

  src = touch-gestures-src;
}

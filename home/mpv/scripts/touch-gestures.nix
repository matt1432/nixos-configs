{
  mpv-touch-gestures-src,
  buildLua,
  ...
}:
buildLua {
  pname = "touch-gestures";
  version = mpv-touch-gestures-src.shortRev;

  src = mpv-touch-gestures-src;
}

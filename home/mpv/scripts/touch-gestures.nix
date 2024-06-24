{
  buildLua,
  mkVersion,
  mpv-touch-gestures-src,
  ...
}:
buildLua {
  pname = "touch-gestures";
  version = mkVersion mpv-touch-gestures-src;

  src = mpv-touch-gestures-src;
}

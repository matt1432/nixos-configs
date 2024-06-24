{
  buildLua,
  mkVersion,
  mpv-pointer-event-src,
  ...
}:
buildLua {
  pname = "pointer-event";
  version = mkVersion mpv-pointer-event-src;

  src = mpv-pointer-event-src;
}

{
  mpv-pointer-event-src,
  buildLua,
  ...
}:
buildLua {
  pname = "pointer-event";
  version = mpv-pointer-event-src.shortRev;

  src = mpv-pointer-event-src;
}

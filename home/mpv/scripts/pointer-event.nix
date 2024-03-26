{
  pointer-event-src,
  buildLua,
  ...
}:
buildLua {
  pname = "pointer-event";
  version = pointer-event-src.shortRev;

  src = pointer-event-src;
}

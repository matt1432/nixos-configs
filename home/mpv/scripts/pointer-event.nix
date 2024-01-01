{
  pointer-event-src,
  buildLua,
  ...
}:
buildLua {
  pname = "pointer-event";
  version = pointer-event-src.rev;

  src = pointer-event-src;
}

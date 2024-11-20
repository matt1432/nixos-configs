{
  buildLua,
  eisa-scripts-src,
  mkVersion,
  ...
}:
buildLua rec {
  pname = "undo-redo";
  version = mkVersion eisa-scripts-src;

  src = eisa-scripts-src;
  scriptPath = "${src}/scripts/UndoRedo.lua";
}

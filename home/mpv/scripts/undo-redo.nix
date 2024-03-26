{
  eisa-scripts-src,
  buildLua,
  ...
}:
buildLua rec {
  pname = "undo-redo";
  version = eisa-scripts-src.shortRev;

  src = eisa-scripts-src;
  scriptPath = "${src}/scripts/UndoRedo.lua";
}

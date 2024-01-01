{
  eisa-scripts-src,
  buildLua,
  ...
}:
buildLua rec {
  pname = "undo-redo";
  version = eisa-scripts-src.rev;

  src = eisa-scripts-src;
  scriptPath = "${src}/scripts/UndoRedo.lua";
}

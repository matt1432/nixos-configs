{
  # nix build inputs
  lib,
  buildLua,
  mkVersion,
  eisa-scripts-src,
  ...
}:
buildLua rec {
  pname = "undo-redo";
  version = mkVersion eisa-scripts-src;

  src = eisa-scripts-src;
  scriptPath = "${src}/scripts/UndoRedo.lua";

  meta = {
    license = lib.licenses.bsd2;
    homepage = "https://github.com/Eisa01/mpv-scripts?tab=readme-ov-file#undoredo";
    description = ''
      Accidentally seeked? No worries, simply undo..
      Undo is not enough to fix your accidental seek? Well now you can redo as well..
    '';
  };
}

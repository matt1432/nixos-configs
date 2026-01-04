{pkgs, ...} @ inputs:
pkgs.lib.makeScope pkgs.newScope (mpv: let
  buildLuaScript = file:
    mpv.callPackage file (inputs // {inherit (pkgs.mpvScripts) buildLua;});
in {
  modernz = buildLuaScript ./modernz;
  pointer-event = buildLuaScript ./pointer-event;
  touch-gestures = buildLuaScript ./touch-gestures;
  kdialog-open-files = buildLuaScript ./kdialog-open-files;
  persist-properties = buildLuaScript ./persist-properties;
  undo-redo = buildLuaScript ./undo-redo;
})

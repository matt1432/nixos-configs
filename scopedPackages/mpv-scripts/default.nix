{pkgs, ...} @ inputs:
pkgs.lib.makeScope pkgs.newScope (mpv: let
  buildLua =
    mpv.callPackage
    "${pkgs.path}/pkgs/applications/video/mpv/scripts/buildLua.nix" {};

  buildLuaScript = file:
    mpv.callPackage file (inputs // {inherit buildLua;});
in {
  modernz = buildLuaScript ./modernz;
  pointer-event = buildLuaScript ./pointer-event;
  touch-gestures = buildLuaScript ./touch-gestures;
  kdialog-open-files = buildLuaScript ./kdialog-open-files;
  persist-properties = buildLuaScript ./persist-properties;
  undo-redo = buildLuaScript ./undo-redo;
})

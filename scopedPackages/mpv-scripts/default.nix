{pkgs, ...} @ inputs:
pkgs.lib.makeScope pkgs.newScope (mpv: let
  buildLua =
    mpv.callPackage
    "${pkgs.path}/pkgs/applications/video/mpv/scripts/buildLua.nix" {};

  buildLuaScript = file:
    mpv.callPackage file (inputs // {inherit buildLua;});
in {
  modernz = buildLuaScript ./modernz.nix;
  pointer-event = buildLuaScript ./pointer-event.nix;
  touch-gestures = buildLuaScript ./touch-gestures.nix;
  kdialog-open-files = buildLuaScript ./kdialog-open-files.nix;
  persist-properties = buildLuaScript ./persist-properties.nix;
  undo-redo = buildLuaScript ./undo-redo.nix;
})

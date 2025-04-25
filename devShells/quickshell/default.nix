{
  lib,
  mkShell,
  kdePackages,
  quickshell,
  ...
}:
mkShell {
  packages = [
    quickshell
  ];

  shellHook = ''
    export QML2_IMPORT_PATH="$QML2_IMPORT_PATH:${lib.makeSearchPath "lib/qt-6/qml" [
      quickshell
      kdePackages.qtdeclarative
    ]}"
  '';

  meta.description = ''
    Shell that provides the quickshell executable with `QML2_IMPORT_PATH`
    correctly defined for quickshell development.
  '';
}

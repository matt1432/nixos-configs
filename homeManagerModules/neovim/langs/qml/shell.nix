{
  lib,
  mkShell,
  kdePackages,
  quickshell,
  ...
}:
mkShell {
  packages = [
    kdePackages.qtdeclarative
  ];

  shellHook = ''
    export QML2_IMPORT_PATH="$QML2_IMPORT_PATH:${lib.makeSearchPath "lib/qt-6/qml" [
      quickshell
      kdePackages.qtdeclarative
    ]}"
  '';

  meta.platforms = ["x86_64-linux"];
}

{
  mkShell,
  gradle,
  kotlin-language-server,
  ...
}:
mkShell {
  packages = [
    gradle
    kotlin-language-server
  ];
}

{
  mkShell,
  kotlin-language-server,
  ...
}:
mkShell {
  packages = [
    kotlin-language-server
  ];
}

{
  mkShell,
  lua-language-server,
  ...
}:
mkShell {
  packages = [
    lua-language-server
  ];
}

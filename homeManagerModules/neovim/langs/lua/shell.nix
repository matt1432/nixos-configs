{
  mkShell,
  lua-language-server,
  stylua,
  ...
}:
mkShell {
  packages = [
    lua-language-server
    stylua
  ];
}

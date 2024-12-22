{
  mkShell,
  vscode-langservers-extracted,
  yaml-language-server,
  ...
}:
mkShell {
  packages = [
    vscode-langservers-extracted
    yaml-language-server
  ];
}

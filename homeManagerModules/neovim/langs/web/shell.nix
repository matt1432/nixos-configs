{
  mkShell,
  neovim-node-client,
  nodejs_latest,
  vscode-langservers-extracted,
  nodePackages,
  some-sass-language-server,
  ...
}:
mkShell {
  packages = [
    neovim-node-client
    nodejs_latest
    vscode-langservers-extracted

    nodePackages.npm

    nodePackages.typescript-language-server

    some-sass-language-server
  ];
}

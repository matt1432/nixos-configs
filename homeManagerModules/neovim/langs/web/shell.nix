{
  mkShell,
  neovim-node-client,
  nodejs_latest,
  vscode-langservers-extracted,
  nodePackages,
  self,
  system,
  ...
}:
mkShell {
  packages = [
    neovim-node-client
    nodejs_latest
    vscode-langservers-extracted

    nodePackages.npm

    self.packages.${system}.some-sass-language-server
  ];
}

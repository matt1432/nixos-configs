{
  mkShell,
  go,
  gopls,
  ...
}:
mkShell {
  packages = [
    go
    gopls
  ];
}

{
  mkShell,
  basedpyright,
  ruff,
  ...
}:
mkShell {
  packages = [
    basedpyright
    ruff
  ];
}

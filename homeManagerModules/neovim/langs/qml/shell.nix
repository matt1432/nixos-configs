{
  mkShell,
  kdePackages,
  ...
}:
mkShell {
  packages = [
    kdePackages.qtdeclarative
  ];
}

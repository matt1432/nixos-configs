{
  mkShell,
  dotnetCorePackages,
  ...
}:
mkShell {
  packages = [
    dotnetCorePackages.sdk_9_0
  ];
}

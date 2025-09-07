{
  mkShell,
  dotnetCorePackages,
  roslyn-ls,
  ...
}:
mkShell {
  packages = [
    dotnetCorePackages.sdk_9_0
    roslyn-ls
  ];
}

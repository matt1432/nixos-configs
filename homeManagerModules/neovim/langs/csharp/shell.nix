{
  mkShell,
  dotnetCorePackages,
  roslyn-ls,
  ...
}:
mkShell {
  packages = [
    dotnetCorePackages.sdk_9_0
    # FIXME: build failure
    # roslyn-ls
  ];
}

{
  mkShell,
  dotnetCorePackages,
  roslyn-ls,
  ...
}:
mkShell {
  packages = [
    dotnetCorePackages.sdk_9_0
    # FIXME: https://pr-tracker.nelim.org/?pr=439459
    # roslyn-ls
  ];
}

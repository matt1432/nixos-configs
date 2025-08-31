{
  mkShell,
  dotnetCorePackages,
  roslyn-ls,
  ...
}:
mkShell {
  packages = [
    dotnetCorePackages.sdk_9_0
    # FIXME: https://github.com/NixOS/nixpkgs/issues/438429
    # roslyn-ls
  ];
}

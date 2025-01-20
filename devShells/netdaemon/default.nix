{
  mkShell,
  dotnetCorePackages,
  ...
}:
mkShell {
  packages = [
    dotnetCorePackages.sdk_9_0
  ];

  meta.description = ''
    Shell that makes sure we have the right dotnet-sdk version for NetDaemon development.
  '';
}

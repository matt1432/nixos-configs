{
  buildDotnetModule,
  dotnetCorePackages,
}:
buildDotnetModule {
  pname = "netdaemon-config";
  version = "0.0.0";

  src =
    builtins.filterSource
    (file: type:
      (type != "directory")
      || (baseNameOf file != "default.nix" && baseNameOf file != "package.nix"))
    ./.;

  projectFile = "netdaemon.csproj";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  executables = [];
}

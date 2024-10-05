{
  buildDotnetModule,
  dotnetCorePackages,
}: let
  pname = "netdaemon-config";
in
  buildDotnetModule {
    inherit pname;
    version = "0.0.0";

    src =
      builtins.filterSource
      (file: type:
        (type != "directory")
        || (builtins.all (f: baseNameOf file != f) [
          ".envrc"
          "deps.nix"
          "default.nix"
          "netdaemon.nix"
          "package.nix"
        ]))
      ./.;

    projectFile = "netdaemon.csproj";
    nugetDeps = ./deps.nix;

    dotnet-sdk = dotnetCorePackages.sdk_8_0;
    dotnet-runtime = dotnetCorePackages.runtime_8_0;
    executables = [];

    postFixup = ''
      cp -r $out/lib/${pname} $lib
    '';

    outputs = ["out" "lib"];
  }

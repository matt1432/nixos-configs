{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
}: let
  inherit (lib) any hasSuffix;
  pname = "netdaemon-config";
in
  buildDotnetModule {
    inherit pname;
    version = "0.0.0";

    src = builtins.path {
      name = "src";
      path = ./.;
      filter = file: type:
        (type != "directory")
        || any (s: hasSuffix s file) [".cs" ".csproj"];
    };

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

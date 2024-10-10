{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
}: let
  inherit (lib) any hasInfix hasSuffix removeSuffix;

  srcDirs = ["apps"];
  srcPatterns = [".cs" ".csproj" ".json" ".version"];

  pname = "netdaemon-config";
in
  buildDotnetModule {
    inherit pname;
    version = removeSuffix "\n" (builtins.readFile ./.version);

    src = builtins.path {
      name = "netdaemon-src";
      path = ./.;
      filter = file: type:
        (type == "directory" && any (s: hasInfix s file) srcDirs)
        || any (s: hasSuffix s file) srcPatterns;
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

{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
}: let
  inherit (lib) any hasInfix hasSuffix removeSuffix;

  srcDirs = ["apps"];
  srcPatterns = [".cs" ".csproj" ".json" ".version" "HomeAssistantGenerated"];

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

    preBuild = ''
      mv HomeAssistantGenerated HomeAssistantGenerated.cs
    '';

    projectFile = "netdaemon.csproj";
    nugetDeps = ./deps.json;

    dotnet-sdk = dotnetCorePackages.sdk_9_0;
    dotnet-runtime = dotnetCorePackages.runtime_9_0;
    executables = [];

    postFixup = ''
      cp -r $out/lib/${pname} $netdaemonConfig
    '';

    outputs = ["out" "netdaemonConfig"];
  }

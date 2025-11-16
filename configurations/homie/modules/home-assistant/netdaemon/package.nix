{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
}: let
  inherit (lib) any hasInfix hasSuffix replaceStrings;

  srcDirs = ["apps"];
  srcPatterns = [".cs" ".csproj" ".json" "HomeAssistantGenerated"];

  pname = "netdaemon-config";

  versionFile = import ./version.nix;
  version = versionFile.version;
  dotnetVersion = replaceStrings ["."] ["_"] versionFile.dotnetVersion;
in
  buildDotnetModule {
    inherit pname version;

    src = builtins.path {
      name = "netdaemon-src";
      path = ./.;
      filter = file: type:
        (type == "directory" && any (s: hasInfix s file) srcDirs)
        || any (s: hasSuffix s file) srcPatterns;
    };

    postPatch = ''
      mv HomeAssistantGenerated HomeAssistantGenerated.cs
      echo -n ${version} > .version
      echo -n net${versionFile.dotnetVersion} > .dotnetversion
    '';

    projectFile = "netdaemon.csproj";
    nugetDeps = ./deps.json;

    dotnet-sdk = dotnetCorePackages."sdk_${dotnetVersion}";
    dotnet-runtime = dotnetCorePackages."runtime_${dotnetVersion}";
    executables = [];

    postFixup = ''
      cp -r $out/lib/${pname} $netdaemonConfig
    '';

    outputs = ["out" "netdaemonConfig"];
  }

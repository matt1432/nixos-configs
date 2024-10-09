{
  buildDotnetModule,
  dotnetCorePackages,
  nix-gitignore,
}: let
  pname = "netdaemon-config";
in
  buildDotnetModule {
    inherit pname;
    version = "0.0.0";

    src =
      nix-gitignore.gitignoreSource [
        "*.nix"
        ".direnv"
        ".envrc"
        "images"
      ]
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

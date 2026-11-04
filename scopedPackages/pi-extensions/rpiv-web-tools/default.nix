{
  # nix build inputs
  lib,
  buildNpmPackage,
  writeShellApplication,
  # update script deps
  nodejs_latest,
  prefetch-npm-deps,
  jq,
  ...
}: let
  inherit (lib) getExe;
  inherit (builtins) fromJSON readFile;
  package = fromJSON (readFile ./package.json);

  pname = "rpiv-web-tools";
  version = package.dependencies."@juicesharp/rpiv-web-tools";
in
  buildNpmPackage {
    inherit pname version;

    src = ./.;
    dontNpmBuild = true;

    # pi provides its own packages to extensions, so don't install the peer deps
    npmFlags = ["--legacy-peer-deps"];

    # pi loads the extension from $out/node_modules/@juicesharp/rpiv-web-tools
    installPhase = ''
      mkdir -p $out
      cp -r node_modules $out
    '';

    npmDepsHash = "sha256-tH34ykHjaUm7UfJo28SGea7t5WZVzQibXytASDYLR4I=";

    passthru.updateScript = getExe (writeShellApplication {
      name = "update";
      runtimeInputs = [
        nodejs_latest
        prefetch-npm-deps
        jq
      ];
      text = import ./update.nix;
    });

    meta = {
      license = with lib.licenses; [mit];
      homepage = "https://github.com/juicesharp/rpiv-mono/tree/main/packages/rpiv-web-tools";
      description = ''
        Pi extension. Web search and fetch for the model with pluggable providers.
      '';
    };
  }

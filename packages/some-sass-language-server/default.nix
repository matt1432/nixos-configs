{
  # nix build inputs
  lib,
  buildNpmPackage,
  makeWrapper,
  writeShellApplication,
  # update script deps
  nodejs_latest,
  prefetch-npm-deps,
  jq,
  ...
}: let
  inherit (builtins) fromJSON readFile;
  package = fromJSON (readFile ./package.json);

  pname = "some-sass-language-server";
  version = package.dependencies.some-sass-language-server;
in
  buildNpmPackage {
    inherit pname version;

    src = ./.;
    dontNpmBuild = true;

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      mkdir -p $out/bin
      cp -r node_modules $out
      makeWrapper $out/node_modules/.bin/some-sass-language-server $out/bin/some-sass-language-server
    '';

    npmDepsHash = "sha256-BRo71A07BhrioiBFisCR01OrVFTIagVTIClZ2Tpjidk=";

    passthru.updateScript = writeShellApplication {
      name = "update";
      runtimeInputs = [
        nodejs_latest
        prefetch-npm-deps
        jq
      ];
      text = import ./update.nix;
    };

    meta = {
      mainProgram = pname;
      license = with lib.licenses; [isc];
      homepage = "https://github.com/wkillerud/some-sass";
      description = ''
        Some Sass is a language server extension for Visual Studio Code and
        other editors with a language server protocol (LSP) client. It brings
        improved code suggestions, documentation and code navigation for both
        SCSS and indented syntaxes.
      '';
    };
  }

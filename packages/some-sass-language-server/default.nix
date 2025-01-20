{
  lib,
  writeShellApplication,
  nodejs_latest,
  prefetch-npm-deps,
  jq,
  buildNpmPackage,
  makeWrapper,
  ...
}: let
  package = builtins.fromJSON (builtins.readFile ./package.json);
  pname = "some-sass-language-server";
in
  buildNpmPackage {
    inherit pname;
    version = package.dependencies.some-sass-language-server;

    src = ./.;
    dontNpmBuild = true;

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      mkdir -p $out/bin
      cp -r node_modules $out
      makeWrapper $out/node_modules/.bin/some-sass-language-server $out/bin/some-sass-language-server
    '';

    npmDepsHash = "sha256-BRo71A07BhrioiBFisCR01OrVFTIagVTIClZ2Tpjidk=";

    passthru.update = writeShellApplication {
      name = "update";
      runtimeInputs = [
        nodejs_latest
        prefetch-npm-deps
        jq
      ];
      text = import ./update.nix;
    };

    meta = {
      description = "Some Sass is a language server extension for Visual Studio Code and other editors with a language server protocol (LSP) client. It brings improved code suggestions, documentation and code navigation for both SCSS and indented syntaxes.";
      mainProgram = pname;
      homepage = "https://github.com/wkillerud/some-sass";
      license = with lib.licenses; [isc];
    };
  }

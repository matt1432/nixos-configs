{
  writeShellApplication,
  nodejs_latest,
  prefetch-npm-deps,
  jq,
  buildNpmPackage,
  makeWrapper,
  ...
}: let
  package = builtins.fromJSON (builtins.readFile ./package.json);
in
  buildNpmPackage {
    pname = "some-sass-language-server";
    version = package.dependencies.some-sass-language-server;

    src = ./.;
    dontNpmBuild = true;

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      mkdir -p $out/bin
      cp -r node_modules $out
      makeWrapper $out/node_modules/.bin/some-sass-language-server $out/bin/some-sass-language-server
    '';

    npmDepsHash = "sha256-qu3oxvROX466DCJNN/RPnkgEfYqtyAVKgzWx8QI1jAI=";

    passthru.update = writeShellApplication {
      name = "update";
      runtimeInputs = [
        nodejs_latest
        prefetch-npm-deps
        jq
      ];
      text = import ./update.nix;
    };
  }

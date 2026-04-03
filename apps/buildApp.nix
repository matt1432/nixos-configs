{
  lib,
  src,
  npmDepsHash,
  runtimeInputs,
  buildNpmPackage,
  meta,
  makeWrapper,
  nodejs_latest,
  jq,
  python3Packages,
  ...
}: let
  inherit (lib) concatMapStringsSep;
  inherit (builtins) fromJSON readFile;

  jsonlint = "${python3Packages.demjson3}/bin/jsonlint";

  packageJSON = fromJSON (readFile "${src}/package.json");

  pname = packageJSON.name;
  inherit (packageJSON) version;
in
  buildNpmPackage {
    inherit pname version src runtimeInputs npmDepsHash;

    prePatch = ''
      # Patch tsconfig
      mv ./tsconfig.json ./project.json
      ${jsonlint} -SF ./project.json
      ${jsonlint} -SF -o ./base.json ${./config/tsconfig.base.json}
      ${jq}/bin/jq -sr '.[0] * .[1] | del(.extends)' ./project.json ./base.json > ./tsconfig.json
      rm base.json project.json
    '';

    nativeBuildInputs = [makeWrapper];

    postInstall = ''
      wrapProgram $out/bin/${pname} \
          --prefix PATH : ${concatMapStringsSep ":" (p: p + "/bin") runtimeInputs}
    '';

    doCheck = true;

    checkPhase = ''
      runHook preCheck

      rm eslint.config.ts

      npx tsc

      runHook postCheck
    '';

    nodejs = nodejs_latest;

    meta = {mainProgram = pname;} // meta;
  }

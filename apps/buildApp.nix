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
  ...
}: let
  inherit (lib) boolToString concatMapStringsSep concatStringsSep mapAttrsToList;
  inherit (builtins) fromJSON isBool readFile;

  packageJSON = fromJSON (readFile "${src}/package.json");
  tsconfig = fromJSON (readFile ./config/tsconfig.base.json);

  pname = packageJSON.name;
  inherit (packageJSON) version;
in
  buildNpmPackage {
    inherit pname version src runtimeInputs npmDepsHash;

    prePatch = ''
      # Patch tsconfig
      mv ./tsconfig.json ./project.json
      sed 's/^ *\/\/.*//' ${./config/tsconfig.base.json} > ./base.json
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

      npx tsc ${concatStringsSep " " (mapAttrsToList (n: v:
        if n == "lib"
        then concatMapStringsSep " " (x: "--lib ${x}") v
        else "--${n} ${
          if isBool v
          then boolToString v
          else toString v
        }")
      tsconfig.compilerOptions)} src/app.ts

      runHook postCheck
    '';

    nodejs = nodejs_latest;

    meta = {mainProgram = pname;} // meta;
  }

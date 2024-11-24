{
  runtimeInputs,
  npmDepsHash,
  src,
  lib,
  buildNpmPackage,
  makeWrapper,
  nodejs_latest,
  jq,
  ...
}: let
  inherit (lib) concatMapStringsSep getBin;
  inherit (builtins) fromJSON readFile;

  packageJSON = fromJSON (readFile "${src}/package.json");
in
  buildNpmPackage rec {
    pname = packageJSON.name;
    inherit (packageJSON) version;

    inherit src runtimeInputs npmDepsHash;

    prePatch = ''
      mv ./tsconfig.json ./project.json
      sed 's/^ *\/\/.*//' ${../tsconfig.json} > ./base.json
      ${jq}/bin/jq -sr '.[0] * .[1] | del(.extends)' ./project.json ./base.json > ./tsconfig.json
      rm base.json project.json
    '';

    nativeBuildInputs = [makeWrapper];

    postInstall = ''
      wrapProgram $out/bin/${pname} \
          --prefix PATH : ${concatMapStringsSep ":" (p: getBin p) runtimeInputs}
    '';

    nodejs = nodejs_latest;
    meta.mainProgram = pname;
  }

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
  inherit (lib) concatMapStringsSep;
  inherit (builtins) fromJSON readFile;

  packageJSON = fromJSON (readFile "${src}/package.json");
  pname = packageJSON.name;
  inherit (packageJSON) version;
in
  buildNpmPackage {
    inherit pname version src runtimeInputs npmDepsHash;

    prePatch = ''
      mv ./tsconfig.json ./project.json
      sed 's/^ *\/\/.*//' ${./config/tsconfig.json} > ./base.json
      ${jq}/bin/jq -sr '.[0] * .[1] | del(.extends)' ./project.json ./base.json > ./tsconfig.json
      rm base.json project.json
    '';

    nativeBuildInputs = [makeWrapper];

    postInstall = ''
      wrapProgram $out/bin/${pname} \
          --prefix PATH : ${concatMapStringsSep ":" (p: p + "/bin") runtimeInputs}
    '';

    nodejs = nodejs_latest;

    meta = {mainProgram = pname;} // meta;
  }

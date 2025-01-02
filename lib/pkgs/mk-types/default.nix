{
  lib,
  pname,
  withGirNames,
  buildNpmPackage,
  ts-for-gir-src,
  delete ? [],
  ...
}: let
  inherit (lib) concatMapStringsSep optionalString;

  buildPhase = ''
    npx @ts-for-gir/cli generate ${concatMapStringsSep " " (p: p.girName) withGirNames} \
        ${concatMapStringsSep "\n" (p: "-g ${p.package.dev}/share/gir-1.0 \\") withGirNames}
        -g ${ts-for-gir-src}/girs \
        --ignoreVersionConflicts \
        -o ./types
  '';
in
  buildNpmPackage {
    pname = "${pname}-types";
    version = "0.0.0";

    npmDepsHash = "sha256-QqLwPJJbAeiGMKUwhpUL1LME0DYm/rIgu8pAyt98KVI=";

    src = ./.;
    dontNpmBuild = true;

    buildPhase = ''
      echo -e '\n${buildPhase}\n'
      ${buildPhase}
    '';

    installPhase = ''
      ${optionalString (delete != []) (
        "rm -f " + concatMapStringsSep " " (file: "./types/${file}.d.ts") delete
      )}
      cp -r ./types $out
    '';
  }

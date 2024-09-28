{
  lib,
  pname,
  withGirNames,
  buildNpmPackage,
  ts-for-gir-src,
  ...
}: let
  inherit (lib) concatMapStringsSep;
in
  buildNpmPackage {
    pname = "${pname}-types";
    version = "0.0.0";

    npmDepsHash = "sha256-3ll4Xd5F8ZH/7q/gOF0jgerM6QRk71d93XIwtDssfxU=";

    src = ./.;
    dontNpmBuild = true;

    buildPhase = ''
      npx @ts-for-gir/cli generate ${concatMapStringsSep " " (p: p.girName) withGirNames} \
          ${concatMapStringsSep "\n" (p: "-g ${p.package.dev}/share/gir-1.0 \\") withGirNames}
          -g ${ts-for-gir-src}/girs \
          --ignoreVersionConflicts \
          -o ./types
    '';

    installPhase = ''
      cp -r ./types $out
    '';
  }

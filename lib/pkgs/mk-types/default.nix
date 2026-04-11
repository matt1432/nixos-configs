{
  lib,
  pname,
  withGirNames,
  buildNpmPackage,
  ts-for-gir-src,
  ...
}: let
  inherit (lib) concatMapStringsSep;

  buildPhase = ''
    npx @ts-for-gir/cli generate \
    ${concatMapStringsSep "\n" (p: "    ${p.girName} \\") withGirNames}
    ${concatMapStringsSep "\n" (p: "    -g ${p.package.dev or p.package}/share/gir-1.0 \\") withGirNames}
        -g ${ts-for-gir-src}/girs \
        --ignoreVersionConflicts \
        -o ./types
  '';
in
  buildNpmPackage {
    pname = "${pname}-types";
    version = "0.0.0";

    npmDepsHash = "sha256-FKpCJIS8M+EfH8UWWmX5w4LIN8ZgWi3X7oYPbg94gAI=";

    src = ./.;
    dontNpmBuild = true;

    buildPhase = ''
      cp ./node_modules/@ts-for-gir/{cli/,}package.json
      echo -e '\n${buildPhase}\n'
      ${buildPhase}
    '';

    installPhase = ''
      cp -r ./types $out
    '';
  }

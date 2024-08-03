{
  package,
  girName,
  buildNpmPackage,
  ts-for-gir-src,
  ...
}:
buildNpmPackage {
  pname = "${package.pname}-types";
  inherit (package) version;

  npmDepsHash = "sha256-8De8tRUKzRhD1jyx0anYNPMhxZyIr2nI45HdK6nb8jI=";

  src = ./.;
  dontNpmBuild = true;

  buildPhase = ''
    npx @ts-for-gir/cli generate ${girName} \
        -g ${package.dev}/share/gir-1.0 \
        -g ${ts-for-gir-src}/girs \
        --ignoreVersionConflicts \
        --package \
        -e gjs -o ./types
  '';

  installPhase = ''
    cp -r ./types $out
  '';
}

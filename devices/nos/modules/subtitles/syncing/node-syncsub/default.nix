{
  buildNpmPackage,
  nodejs_20,
  subsync,
  typescript,
  ...
}:
buildNpmPackage {
  name = "node-syncsub";
  src = ./.;
  npmDepsHash = "sha256-kQBZ13bTMxZnv45IwyIV0cYA5tjr4KKU1cpDNx02th0=
";

  nativeBuildInputs = [
    subsync
    typescript
    nodejs_20
  ];

  buildPhase = ''
    tsc -p tsconfig.json
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv node_modules package.json $out

    echo '#!/usr/bin/env node' > $out/bin/node-syncsub
    cat ./build/main.js >> $out/bin/node-syncsub
    chmod +x $out/bin/node-syncsub
  '';
}

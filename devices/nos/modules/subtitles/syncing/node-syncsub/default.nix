{
  buildNpmPackage,
  ffmpeg,
  nodejs_20,
  subsync,
  typescript,
  ...
}:
buildNpmPackage {
  name = "node-syncsub";
  src = ./.;
  npmDepsHash = "sha256-O00VQPCUX6T+rtK3VcAibBipXFwNs4AFA3251qycPBQ=";

  nativeBuildInputs = [
    nodejs_20
    ffmpeg
    subsync
    typescript
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

{
  buildNpmPackage,
  ffmpeg,
  nodejs_20,
  subsync,
  symlinkJoin,
  typescript,
  ...
}: let
  nodeSubSync = buildNpmPackage {
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
      rm ./build/main.js
      chmod +x $out/bin/node-syncsub

      mv ./build/**.js $out/bin
    '';
  };
in
  symlinkJoin {
    name = "node-syncsub";
    meta.mainProgram = "node-syncsub";
    paths = [
      ffmpeg
      subsync
      nodeSubSync
    ];
  }

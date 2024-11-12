{
  buildNpmPackage,
  ffmpeg-full,
  nodejs_20,
  typescript,
  writeShellApplication,
  ...
}: let
  pname = "extract-subs";

  extract-subs = buildNpmPackage {
    name = "${pname}-npm";
    src = ./.;
    npmDepsHash = "sha256-WXkg4e5Nh3+haCbm+XJ1CB7rsA2uV/7eZUaOUl/NVk0=";

    nativeBuildInputs = [
      nodejs_20
      typescript
    ];

    buildPhase = ''
      tsc -p tsconfig.json
    '';

    installPhase = ''
      mkdir -p $out/bin
      mv node_modules package.json $out

      echo '#!/usr/bin/env node' > $out/bin/${pname}
      cat ./build/main.js >> $out/bin/${pname}
      rm ./build/main.js
      chmod +x $out/bin/${pname}

      mv ./build/**.js $out/bin
    '';
  };
in
  writeShellApplication {
    name = pname;

    runtimeInputs = [
      ffmpeg-full
      extract-subs
    ];

    text = ''
      exec ${pname} "$@"
    '';
  }

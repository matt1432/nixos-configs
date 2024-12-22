{
  buildNpmPackage,
  fetchFromGitHub,
  nodePackages,
  python3,
  stdenv,
  cctools,
  IOKit ? {},
  lib,
  enableLocalIcons ? true,
  git,
}: let
  inherit (lib) optionals optionalString;

  installLocalIcons = import ./icons.nix {inherit fetchFromGitHub;};

  pname = "homepage-dashboard";
  version = "0.10.2";
in
  buildNpmPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "gethomepage";
      repo = "homepage";
      rev = "v${version}";
      hash = "sha256-1eBuRBtvdJkTKUy+z6Ss5XfgMHxg6fB5PY4QQbKLGMo=";
    };

    npmDepsHash = "sha256-AW7lNkvQeeHkAf6Q23912LiSHJMelR9+4KVSKdlFqd0=";

    preBuild = ''
      mkdir -p config
    '';

    postBuild = ''
      # Add a shebang to the server js file, then patch the shebang.
      sed -i '1s|^|#!/usr/bin/env node\n|' .next/standalone/server.js
      patchShebangs .next/standalone/server.js
    '';

    nativeBuildInputs = [git] ++ optionals stdenv.hostPlatform.isDarwin [cctools];

    buildInputs =
      [
        nodePackages.node-gyp-build
      ]
      ++ optionals stdenv.hostPlatform.isDarwin [IOKit];

    env.PYTHON = "${python3}/bin/python";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{share,bin}

      cp -r .next/standalone $out/share/homepage/
      cp -r public $out/share/homepage/public

      mkdir -p $out/share/homepage/.next
      cp -r .next/static $out/share/homepage/.next/static

      chmod +x $out/share/homepage/server.js

      # This patch must be applied here, as it's patching the `dist` directory
      # of NextJS. Without this, homepage-dashboard errors when trying to
      # write its prerender cache.
      #
      # This patch ensures that the cache implementation respects the env
      # variable `HOMEPAGE_CACHE_DIR`, which is set by default in the
      # wrapper below.
      pushd $out
      git apply ${./prerender_cache_path.patch}
      popd

      makeWrapper $out/share/homepage/server.js $out/bin/homepage \
        --set-default PORT 3000 \
        --set-default HOMEPAGE_CONFIG_DIR /var/lib/homepage-dashboard \
        --set-default HOMEPAGE_CACHE_DIR /var/cache/homepage-dashboard

      ${optionalString enableLocalIcons installLocalIcons}

      runHook postInstall
    '';

    doDist = false;

    meta = {
      description = "Highly customisable dashboard with Docker and service API integrations";
      changelog = "https://github.com/gethomepage/homepage/releases/tag/v${version}";
      mainProgram = "homepage";
      homepage = "https://gethomepage.dev";
      license = lib.licenses.gpl3;
    };
  }

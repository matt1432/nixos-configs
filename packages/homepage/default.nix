{
  # params
  enableLocalIcons ? true,
  # nix build inputs
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  # deps
  cctools,
  git,
  nodePackages,
  python3,
  IOKit ? {},
}: let
  inherit (lib) optionals optionalString;

  installLocalIcons = import ./icons.nix {inherit fetchFromGitHub;};

  pname = "homepage-dashboard";
  version = "0.10.9";
in
  buildNpmPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "gethomepage";
      repo = "homepage";
      rev = "v${version}";
      hash = "sha256-q8+uoikHMQVuTrVSH8tPsoI5655ZStMc/7tmoAfoZIY=";
    };

    npmDepsHash = "sha256-N39gwct2U4UxlIL5ceDzzU7HpA6xh2WksrZNxGz04PU=";

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
      mainProgram = "homepage";
      license = lib.licenses.gpl3;
      homepage = "https://gethomepage.dev";
      changelog = "https://github.com/gethomepage/homepage/releases/tag/v${version}";
      description = ''
        Highly customisable dashboard with Docker and service API integrations.
      '';
    };
  }

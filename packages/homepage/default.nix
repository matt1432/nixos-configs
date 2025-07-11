{
  # nix build inputs
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  # deps
  nodejs,
  pnpm,
  # params
  enableLocalIcons ? true,
  ...
}: let
  inherit (lib) getExe optionalString;

  installLocalIcons = import ./icons.nix {inherit fetchFromGitHub;};
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "homepage-dashboard";
    version = "1.3.2";

    src = fetchFromGitHub {
      owner = "gethomepage";
      repo = "homepage";
      rev = "v${finalAttrs.version}";
      hash = "sha256-45Z2XS+ij6J6WSCb9/oDQa2eC9wKu+D7ncYwcB6K5gQ=";
    };

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      hash = "sha256-aPkXHKG3vDsfYqYx9q9+2wZhuFqmPcXdoBqOfAvW9oA=";
    };

    nativeBuildInputs = [
      makeWrapper
      nodejs
      pnpm.configHook
    ];

    buildPhase = ''
      pnpm build

      # Add a shebang to the server js file
      sed -i '1s|^|#!${getExe nodejs}\n|' .next/standalone/server.js
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{share,bin}

      # Without this, homepage-dashboard errors when trying to
      # write its prerender cache.
      #
      # This ensures that the cache implementation respects the env
      # variable `HOMEPAGE_CACHE_DIR`, which is set by default in the
      # wrapper below.
      substituteInPlace .next/standalone/node_modules/next/dist/server/lib/incremental-cache/file-system-cache.js --replace-fail \
        "this.serverDistDir = ctx.serverDistDir;" \
        "this.serverDistDir = require('node:path').join(process.env.HOMEPAGE_CACHE_DIR, \"homepage\");"

      cp -r .next/standalone $out/share/homepage/
      cp -r public $out/share/homepage/public

      mkdir -p $out/share/homepage/.next
      cp -r .next/static $out/share/homepage/.next/static

      chmod +x $out/share/homepage/server.js

      makeWrapper $out/share/homepage/server.js $out/bin/homepage \
        --set-default PORT 3000 \
        --set-default HOMEPAGE_CONFIG_DIR /var/lib/homepage-dashboard \
        --set-default HOMEPAGE_CACHE_DIR /var/cache/homepage-dashboard

      ${optionalString enableLocalIcons installLocalIcons}

      runHook postInstall
    '';

    meta = {
      mainProgram = "homepage";
      license = lib.licenses.gpl3;
      homepage = "https://gethomepage.dev";
      changelog = "https://github.com/gethomepage/homepage/releases/tag/v${finalAttrs.version}";
      description = ''
        Highly customisable dashboard with Docker and service API integrations.
      '';
    };
  })

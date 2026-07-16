{
  # nix build inputs
  lib,
  stdenv,
  fetchPnpmDeps,
  pnpmConfigHook,
  custom-sidebar-src,
  # deps
  nodejs,
  pnpm_10,
  ...
}: let
  inherit (builtins) fromJSON readFile;

  package = fromJSON (readFile "${custom-sidebar-src}/package.json");
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "custom-sidebar";
    version = "${package.version}+${custom-sidebar-src.shortRev}";

    src = custom-sidebar-src;

    nativeBuildInputs = [
      nodejs
      pnpm_10
      pnpmConfigHook
    ];

    buildPhase = ''
      npm run build
    '';

    installPhase = ''
      mkdir "$out"
      cp ./dist/* "$out"
    '';

    pnpmDeps = fetchPnpmDeps {
      pnpm = pnpm_10;
      fetcherVersion = 3;
      inherit (finalAttrs) pname version src;
      hash = "sha256-cwyhL2fC4j7XDayS/kaVCTOTdQ0BqfUgC7kp+l1fk8M=";
    };

    passthru.updateScript = ./update.sh;

    meta = {
      license = lib.licenses.asl20;
      homepage = "https://github.com/elchininet/custom-sidebar";
      description = ''
        Custom HACS plugin that allows you to personalise the
        Home Assistant's sidebar per user or device basis.
      '';
    };
  })

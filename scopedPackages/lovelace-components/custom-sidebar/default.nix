{
  # nix build inputs
  lib,
  stdenv,
  custom-sidebar-src,
  # deps
  nodejs,
  pnpm,
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
      pnpm.configHook
    ];

    buildPhase = ''
      npm run build
    '';

    installPhase = ''
      mkdir $out
      cp ./dist/* $out
    '';

    pnpmDeps = pnpm.fetchDeps {
      fetcherVersion = 1;
      inherit (finalAttrs) pname version src;
      hash = "sha256-4928fyjVZ6C4Fyt2+c+cWSOeyCrix2xrhufNrxGZSAU=";
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

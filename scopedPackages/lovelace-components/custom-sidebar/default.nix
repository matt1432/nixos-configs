{
  # nix build inputs
  lib,
  stdenv,
  concatTextFile,
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
      inherit (finalAttrs) pname version src;
      hash = "sha256-S+wv8WFWmQAmA84ZZNWyvS0b6qwPDx81E2qqWIyfzcI=";
    };

    passthru.updateScript = concatTextFile {
      name = "update";
      files = [./update.sh];
      executable = true;
      destination = "/bin/update";
    };

    meta = {
      license = lib.licenses.asl20;
      homepage = "https://github.com/elchininet/custom-sidebar";
      description = ''
        Custom HACS plugin that allows you to personalise the
        Home Assistant's sidebar per user or device basis.
      '';
    };
  })

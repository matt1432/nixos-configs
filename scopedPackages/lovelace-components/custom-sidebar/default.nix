{
  concatTextFile,
  custom-sidebar-src,
  nodejs,
  pnpm,
  stdenv,
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
      hash = "sha256-vAZkr4PLkIMkVr/hFEY6ZBP9W793lxs69LeA/FRUyPY=";
    };

    passthru.updateScript = concatTextFile {
      name = "update";
      files = [./update.sh];
      executable = true;
      destination = "/bin/update";
    };
  })

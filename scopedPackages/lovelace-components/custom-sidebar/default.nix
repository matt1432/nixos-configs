{
  concatTextFile,
  custom-sidebar-src,
  nodejs,
  pnpm,
  stdenv,
  ...
}: let
  package = builtins.fromJSON (builtins.readFile "${custom-sidebar-src}/package.json");
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "custom-sidebar";
    inherit (package) version;

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
      hash = "sha256-u1dmQZgVQEXgkcjswlKMLwqw4uCwSbxG75U4eMLCD80=";
    };

    passthru.update = concatTextFile {
      name = "update";
      files = [./update.sh];
      executable = true;
      destination = "/bin/update";
    };
  })

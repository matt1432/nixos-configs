{
  concatTextFile,
  custom-sidebar-src,
  nodejs,
  pnpm,
  stdenv,
  nix-update-script,
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
      hash = "sha256-II8expO942jHylgbiePr5+V+t+UVh7fenffoyVFn/8k=";
    };

    passthru.updateScript = let
      script = "${concatTextFile {
        name = "update";
        files = [./update.sh];
        executable = true;
        destination = "/bin/update";
      }}/bin/update";
    in
      nix-update-script {
        extraArgs = [
          "--version=skip"
          "; ${script}"
        ];
      };
  })

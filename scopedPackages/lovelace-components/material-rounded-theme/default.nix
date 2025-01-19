{
  buildNpmPackage,
  concatTextFile,
  material-rounded-theme-src,
  ...
}: let
  package = builtins.fromJSON (builtins.readFile "${material-rounded-theme-src}/package.json");
in
  buildNpmPackage {
    pname = package.name;
    inherit (package) version;

    src = material-rounded-theme-src;
    postPatch = ''
      substituteInPlace ./webpack.config.js --replace-fail "git branch --show-current" "echo main"
    '';

    npmDepsHash = "sha256-Vn4OBTM9MoS0LuU4nDYebncvD6wKmfcLP3gHh0CyfaM=";

    installPhase = ''
      mkdir $out
      cp ./dist/* $out
    '';

    passthru.update = concatTextFile {
      name = "update";
      files = [./update.sh];
      executable = true;
      destination = "/bin/update";
    };
  }

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

    npmDepsHash = "sha256-BlG/IuyJpigw6twUoaxJ5a970JfwBb75FuwgtH4xrCw=";

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

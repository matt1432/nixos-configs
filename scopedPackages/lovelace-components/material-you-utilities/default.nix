{
  buildNpmPackage,
  fetchFromGitHub,
  ...
}: let
  pname = "material-you-utilities";
  version = "1.0.4";
in
  buildNpmPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Nerwyn";
      repo = "ha-${pname}";
      rev = version;
      hash = "sha256-iyGy6dpHZMtU2ap+smZUlLYnFKs6s8SaGAC9Y3jdoiA=";
    };

    postPatch = ''
      substituteInPlace ./webpack.config.js --replace-fail \
          "git branch --show-current" "echo main"
    '';

    installPhase = ''
      mkdir $out
      cp ./dist/material-you-utilities.min.js $out/material-you-utilities.js
    '';

    npmDepsHash = "sha256-5cc610/BhX19k2iREYVoE3c43yDmRJsE0Nvrq/gAVjY=";
  }

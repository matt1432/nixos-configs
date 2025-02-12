{
  buildNpmPackage,
  fetchFromGitHub,
  ...
}: let
  pname = "material-rounded-theme";
  version = "3.0.7";
in
  buildNpmPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Nerwyn";
      repo = pname;
      rev = version;
      hash = "sha256-m2sO3FAuB+CSH2q1SWWfva2i4v7Zjh/OKVoUkeAitH0=";
    };

    postPatch = ''
      substituteInPlace ./webpack.config.js --replace-fail \
          "git branch --show-current" "echo main"
    '';

    npmDepsHash = "sha256-JsDWiRFZkn2Gji07LdsNAQO2W7HdwQRTIs6RPFlzf4A=";

    installPhase = ''
      mkdir $out
      cp ./dist/* $out
    '';
  }

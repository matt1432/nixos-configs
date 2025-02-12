{
  buildNpmPackage,
  fetchFromGitHub,
  ...
}: let
  pname = "material-rounded-theme";
  version = "3.0.6";
in
  buildNpmPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Nerwyn";
      repo = pname;
      rev = version;
      hash = "sha256-OJllOW8YDcmAckcDO5e/fa0zdz7QRX8PgMC0OU0OKIY=";
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

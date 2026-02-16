{
  lib,
  fetchFromGitHub,
  python3Packages,
  ...
}: let
  # TODO: add update script
  pname = "tccutil";
  version = "1.5.1";
in
  python3Packages.buildPythonApplication {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "jacobsalmela";
      repo = "tccutil";
      tag = "v${version}";
      hash = "sha256-gb67xM8daBA03Oq8XCkLdNcPjx5qymz0U859gRaHofs=";
    };

    pyproject = false;
    propagatedBuildInputs = with python3Packages; [
      packaging
    ];

    installPhase = ''
      install -Dm755 tccutil.py $out/bin/${pname}
    '';

    meta = with lib; {
      description = "Command line tool to modify OS X's accessibility database";
      homepage = "https://github.com/jacobsalmela/tccutil";
      license = licenses.gpl2Only;
      platforms = platforms.darwin;
      mainProgram = pname;
    };
  }

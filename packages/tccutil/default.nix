{
  lib,
  python3Packages,
  tccutil-src,
  ...
}: let
  inherit (builtins) head match readFile;

  pname = "tccutil";
  version = head (match ".*util_version = ['\"]([^'\"]*)['\"].*" (readFile "${tccutil-src}/tccutil.py"));
in
  python3Packages.buildPythonApplication {
    inherit pname version;

    src = tccutil-src;

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

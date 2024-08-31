{python3Packages, ...}: let
  inherit (python3Packages) buildPythonPackage utils material-color-utilities;
in
  buildPythonPackage {
    pname = "coloryou";
    version = "0.0.1";

    src = ./.;

    propagatedBuildInputs = [utils material-color-utilities];

    postInstall = ''
      mv -v $out/bin/coloryou.py $out/bin/coloryou
    '';

    meta = {
      description = ''
        Get Material You colors from an image.
      '';
    };
  }

{python3Packages, ...}: let
  inherit (builtins.fromTOML (builtins.readFile ./pyproject.toml)) project;
in
  python3Packages.buildPythonPackage {
    pname = project.name;
    inherit (project) version;
    pyproject = true;

    src = ./.;

    nativeBuildInputs = with python3Packages; [
      setuptools
    ];

    propagatedBuildInputs = with python3Packages; [material-color-utilities];

    postInstall = ''
      mv -v $out/bin/coloryou.py $out/bin/coloryou
    '';

    meta = {
      inherit (project) description;
      homepage = "https://git.nelim.org/matt1432/nixos-configs/src/branch/master/packages/coloryou";
    };
  }

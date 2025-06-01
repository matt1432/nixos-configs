{
  # nix build inputs
  lib,
  # deps
  python3Packages,
  ...
}: let
  inherit (builtins) fromTOML readFile;

  inherit (fromTOML (readFile ./pyproject.toml)) project;
in
  python3Packages.buildPythonApplication rec {
    pname = project.name;
    inherit (project) version;
    format = "pyproject";

    src = ./.;

    build-system = with python3Packages; [hatchling];
    dependencies = with python3Packages; [material-color-utilities];

    meta = {
      mainProgram = pname;
      license = lib.licenses.mit;
      homepage = "https://git.nelim.org/matt1432/nixos-configs/src/branch/master/packages/coloryou";
      inherit (project) description;
    };
  }

{
  # nix build inputs
  lib,
  buildPythonApplication,
  # deps
  hatchling,
  material-color-utilities,
  ...
}: let
  inherit (builtins) fromTOML readFile;

  inherit (fromTOML (readFile ./pyproject.toml)) project;
in
  buildPythonApplication rec {
    pname = project.name;
    inherit (project) version;
    format = "pyproject";

    src = ./.;

    build-system = [hatchling];
    dependencies = [material-color-utilities];

    meta = {
      mainProgram = pname;
      license = lib.licenses.mit;
      homepage = "https://git.nelim.org/matt1432/nixos-configs/src/branch/master/packages/coloryou";
      inherit (project) description;
    };
  }

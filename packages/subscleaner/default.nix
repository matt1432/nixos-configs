{
  # nix build inputs
  lib,
  buildPythonApplication,
  subscleaner-src,
  # deps
  appdirs,
  chardet,
  hatch,
  pysrt,
  ...
}: let
  inherit (builtins) fromTOML readFile;

  pyproject = fromTOML (readFile "${subscleaner-src}/pyproject.toml");

  pname = pyproject.project.name;
  version = "${pyproject.project.version}+${subscleaner-src.shortRev}";
in
  buildPythonApplication {
    inherit pname version;
    format = "pyproject";

    src = subscleaner-src;

    build-system = [hatch];

    dependencies = [
      pysrt
      chardet
      appdirs
    ];

    meta = {
      mainProgram = "subscleaner";
      license = lib.licenses.gpl3Only;
      homepage = "https://gitlab.com/rogs/subscleaner";
      description = ''
        Subscleaner is a Python script that removes advertisements from subtitle files.
        It's designed to help you enjoy your favorite shows and movies without the
        distraction of unwanted ads in the subtitles.
      '';
    };
  }

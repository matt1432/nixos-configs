{
  # nix build inputs
  lib,
  buildPythonApplication,
  Kapowarr-src,
  # deps
  rar,
  # python deps
  aiohttp,
  beautifulsoup4,
  bencoding, # from overrides
  cryptography,
  flask,
  flask-socketio,
  requests,
  setuptools,
  typing-extensions, # from overrides
  waitress,
  websocket-client,
  ...
}: let
  inherit (lib) getExe;
  inherit (builtins) fromTOML readFile;

  pyproject = fromTOML (readFile "${Kapowarr-src}/pyproject.toml");

  pname = "kapowarr";
  version = "${pyproject.project.version}+${Kapowarr-src.shortRev or "dirty"}";
in
  buildPythonApplication {
    inherit pname version;
    format = "pyproject";

    src = Kapowarr-src;

    postPatch = ''
      # TODO: makes sure this works
      substituteInPlace ./src/backend/implementations/converters.py \
          --replace-fail \
              "exe = folder_path('backend', 'lib', Constants.RAR_EXECUTABLES[platform])" \
              "exe = '${getExe rar}'"
    '';

    build-system = [setuptools];

    dependencies = [
      typing-extensions
      requests
      beautifulsoup4
      flask
      waitress
      cryptography
      bencoding
      aiohttp
      flask-socketio
      websocket-client
    ];

    meta = {
      inherit (rar.meta) platforms;
      mainProgram = pname;
      license = lib.licenses.gpl3Only;
      homepage = "https://casvt.github.io/Kapowarr";
      description = ''
        Kapowarr is a software to build and manage a comic book library,
        fitting in the *arr suite of software.
      '';
    };
  }

{
  # nix build inputs
  lib,
  buildPythonApplication,
  Kapowarr-src,
  python,
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

      # Insert import for following substituteInPlace
      sed -i '/# -\*- coding: utf-8 -\*-/a from os import environ' ./src/backend/base/logging.py

      substituteInPlace ./src/backend/base/logging.py --replace-fail \
          "return folder_path(Constants.LOGGER_FILENAME)" \
          "return f\"{environ.get('KAPOWARR_LOG_DIR') or folder_path(*Constants.DB_FOLDER)}/{Constants.LOGGER_FILENAME}\""

      sed -i '/from __future__ import annotations/a from os import environ' ./src/backend/internals/db.py

      substituteInPlace ./src/backend/internals/db.py --replace-fail \
          "db_folder or folder_path(*Constants.DB_FOLDER)" \
          "environ.get('KAPOWARR_STATE_DIR') or folder_path(*Constants.DB_FOLDER)"

      substituteInPlace ./src/backend/internals/settings.py \
          --replace-fail \
              "download_folder: str = folder_path('temp_downloads')" \
              "download_folder: str = environ.get('KAPOWARR_DOWNLOAD_DIR') or folder_path('temp_downloads')"
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

    # Use XDG-ish dirs for configuration. These would otherwise be in the kapowarr package.
    #
    # Using --run as `makeWrapper` evaluates variables for --set and --set-default at build
    # time and then single quotes the vars in the wrapper, thus they wouldn't get expanded.
    # But using --run allows setting default vars that are  evaluated on run and not during
    # build time.
    makeWrapperArgs = [
      ''
        --run "OUTDIR=\"$out\""
        --run '
        configDir="''${XDG_CONFIG_HOME:-$HOME/.config}/kapowarr"
        export KAPOWARR_STATE_DIR="''${KAPOWARR_STATE_DIR-$configDir}"
        export KAPOWARR_LOG_DIR="''${KAPOWARR_LOG_DIR-$configDir}"
        export KAPOWARR_DOWNLOAD_DIR="''${KAPOWARR_DOWNLOAD_DIR-$configDir/temp_downloads}"
        mkdir -p "$KAPOWARR_STATE_DIR" "$KAPOWARR_LOG_DIR"

        if [ ! -f "$KAPOWARR_STATE_DIR/pwa_manifest.json" ]; then
          cat "$OUTDIR/${python.sitePackages}/frontend/static/json/pwa_manifest.json" > "$KAPOWARR_STATE_DIR/pwa_manifest.json"
        fi
        '
      ''
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

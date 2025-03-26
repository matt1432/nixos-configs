{
  # nix build inputs
  lib,
  buildPythonApplication,
  fetchFromGitHub,
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

  pname = "kapowarr";
  version = "1.1.1+pkG4o8O";
in
  buildPythonApplication {
    inherit pname version;
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "Casvt";
      repo = "Kapowarr";
      rev = "a97f907555bf02d5e737812bfa5c189d8cc639ba";
      hash = "sha256-pkG4o8OfLu02M50JSnbrBDNiwnbYEJNutoutwBcLFwU=";
    };

    postPatch = ''
      # FIXME: THIS DOESN'T WORK
      substituteInPlace ./backend/implementations/converters.py \
          --replace-fail \
              "exe = folder_path('backend', 'lib', Constants.RAR_EXECUTABLES[platform])" \
              "exe = '${getExe rar}'"

      # Insert import for following substituteInPlace
      sed -i '/# -\*- coding: utf-8 -\*-/a from os import environ' ./backend/base/logging.py

      substituteInPlace ./backend/base/logging.py --replace-fail \
          "return folder_path(Constants.LOGGER_FILENAME)" \
          "return f\"{environ.get('KAPOWARR_LOG_DIR')}/{Constants.LOGGER_FILENAME}\""

      sed -i '/from __future__ import annotations/a from os import environ' ./backend/internals/db.py

      substituteInPlace ./backend/internals/db.py --replace-fail \
          "db_folder or folder_path(*Constants.DB_FOLDER)" \
          "environ.get('KAPOWARR_STATE_DIR')"

      substituteInPlace ./backend/internals/settings.py \
          --replace-fail \
              "from os import urandom" \
              "from os import urandom, environ" \
          --replace-fail \
              "port: int = 5656" \
              "port: int = int(environ.get('KAPOWARR_PORT'))" \
          --replace-fail \
              "download_folder: str = folder_path('temp_downloads')" \
              "download_folder: str = environ.get('KAPOWARR_DOWNLOAD_DIR')" \
          --replace-fail \
              "filename = folder_path('frontend', 'static', 'json', 'pwa_manifest.json')" \
              "filename = f\"{environ.get('KAPOWARR_STATE_DIR')}/pwa_manifest.json\""
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

    preBuild = ''
      sed -i "s/bs4.*/beautifulsoup4 ~= 4.12.3/" requirements.txt

      cat >> pyproject.toml << EOF

      [build-system]
      build-backend = "setuptools.build_meta"
      requires = ["setuptools"]

      [project]
      name = "${pname}"
      version = "${version}"
      dynamic = ["dependencies"]

      [tool.setuptools]
      script-files = ["Kapowarr.py"]
      py-modules = [
          "Kapowarr",
      ]
      packages = [
          "frontend",
          "frontend.static",
          "backend",
          "backend.base",
          "backend.features",
          "backend.implementations",
          "backend.implementations.direct_clients",
          "backend.implementations.torrent_clients",
          "backend.internals",
          "backend.lib",
      ]
      package-data."frontend" = [ "templates/*" ]
      package-data."frontend.static" = [ "css/*", "img/*", "js/*", "json/*" ]
      dynamic."dependencies".file = [ "requirements.txt" ]
      EOF
    '';

    # Use XDG-ish dirs for configuration. These would otherwise be in the kapowarr package.
    #
    # Using --run as `makeWrapper` evaluates variables for --set and --set-default at build
    # time and then single quotes the vars in the wrapper, thus they wouldn't get expanded.
    # But using --run allows setting default vars that are  evaluated on run and not during
    # build time.
    makeWrapperArgs = [
      "--set-default KAPOWARR_PORT 5656"
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

    postFixup = ''
      # I prefer a clean name for the executable
      mv $out/bin/Kapowarr.py $out/bin/${pname}
    '';

    meta = {
      inherit (rar.meta) platforms;
      mainProgram = pname;
      license = lib.licenses.gpl3Only;
      homepage = "https://casvt.github.io/Kapowarr";
      description = ''
        Kapowarr is a software to build and manage a comic book library,
        fitting in the *arr suite of software
      '';
    };
  }

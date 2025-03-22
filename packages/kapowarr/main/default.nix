{
  # nix build inputs
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  python,
  # deps
  aiohttp,
  beautifulsoup4,
  bencoding, # from overrides
  flask,
  flask-socketio,
  pycryptodome,
  requests,
  setuptools,
  simplejson,
  tenacity, # from overrides
  typing-extensions, # from overrides
  waitress,
  ...
}: let
  pname = "kapowarr";
  version = "1.1.1";
in
  buildPythonApplication {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Casvt";
      repo = "Kapowarr";
      rev = "V${version}";
      hash = "sha256-EeDzgi37f0cA86lQ1Z6hzLgpE3ORfz0YPoMWp5R4uPs=";
    };

    patches = [./raise-errors.patch];

    postPatch = ''
      # Insert import for following substituteInPlace
      sed -i '/# -\*- coding: utf-8 -\*-/a from os import environ' ./backend/base/logging.py

      substituteInPlace ./backend/base/logging.py --replace-fail \
          "return folder_path(Constants.LOGGER_FILENAME)" \
          "return f\"{environ.get('KAPOWARR_LOG_DIR')}/{Constants.LOGGER_FILENAME}\""

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
      pycryptodome
      tenacity
      bencoding
      simplejson
      aiohttp
      flask-socketio
    ];

    preBuild = ''
      cat > setup.py << EOF
      from setuptools import setup, find_packages, find_namespace_packages

      with open('requirements.txt') as f:
           install_requires = f.read().splitlines()

      setup(
        name='${pname}',
        version = '${version}',
        install_requires=install_requires,
        packages=[
          'frontend',
          'backend',
          'backend.base',
          'backend.features',
          'backend.implementations',
          'backend.implementations.torrent_clients',
          'backend.internals',
          'backend.lib',
        ],
        scripts=[
          'Kapowarr.py'
        ],
      )
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

      # Add missing resources that Kapowarr uses at runtime in sitePackages
      cp -r ./frontend/{static,templates} "$out/${python.sitePackages}/frontend"
    '';

    meta = {
      mainProgram = pname;
      license = lib.licenses.gpl3Only;
      homepage = "https://casvt.github.io/Kapowarr";
      description = ''
        Kapowarr is a software to build and manage a comic book library,
        fitting in the *arr suite of software
      '';
    };
  }

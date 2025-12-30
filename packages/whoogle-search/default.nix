{
  lib,
  python3Packages,
  fetchPypi,
  ...
}: let
  pname = "whoogle-search";
  version = "1.2.2";
in
  python3Packages.buildPythonApplication rec {
    inherit pname version;

    pyproject = true;

    src = fetchPypi {
      pname = "whoogle_search";
      inherit version;
      hash = "sha256-QU0VBMAh8MV32C/VDRWC+BHhaejcpiaMfMX3LCze2HM=";
    };

    build-system = with python3Packages; [setuptools];

    dependencies = with python3Packages; [
      attrs
      beautifulsoup4
      brotli
      cachelib
      certifi
      cffi
      chardet
      click
      cryptography
      cssutils
      defusedxml
      flask
      idna
      itsdangerous
      jinja2
      markupsafe
      more-itertools
      packaging
      pluggy
      pycodestyle
      pycparser
      pyopenssl
      pyparsing
      pysocks
      python-dateutil
      requests
      soupsieve
      stem
      urllib3
      validators
      waitress
      wcwidth
      werkzeug
      python-dotenv

      cachetools
      h2
      httpx
    ];

    postInstall = ''
      # This creates renamed versions of the static files for cache busting,
      # without which whoogle will not run. If we don't do this here, whoogle
      # will attempt to create them on startup, which fails since the nix store
      # is read-only.
      python3 $out/${python3Packages.python.sitePackages}/app/__init__.py
    '';

    # We don't want to run nix-update without args when updating from script
    passthru.updateScript = null;

    meta = {
      homepage = "https://github.com/benbusby/whoogle-search";
      description = "Self-hosted, ad-free, privacy-respecting metasearch engine";
      license = lib.licenses.mit;
      mainProgram = pname;
    };
  }

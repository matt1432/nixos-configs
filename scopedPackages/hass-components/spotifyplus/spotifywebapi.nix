{
  # nix build inputs
  lib,
  buildPythonPackage,
  spotifywebapi-src,
  # deps
  lxml,
  numpy,
  oauthlib,
  pillow,
  platformdirs,
  pychromecast,
  pyotp,
  requests,
  requests-oauthlib,
  setuptools,
  soco,
  urllib3,
  zeroconf,
  smartinspect, # overridden in python3Packages
  ...
}: let
  inherit (builtins) elemAt head readFile split;
  tag = head (split "\"" (elemAt (split "VERSION:str = \"" (readFile "${spotifywebapi-src}/spotifywebapipython/const.py")) 2));
in
  buildPythonPackage {
    pname = "spotifywebapiPython";
    version = "${tag}+${spotifywebapi-src.shortRev}";

    pyproject = true;
    build-system = [setuptools];

    src = spotifywebapi-src;

    dependencies = [
      lxml
      numpy
      oauthlib
      pillow
      platformdirs
      pychromecast
      pyotp
      requests
      requests-oauthlib
      setuptools
      soco
      urllib3
      zeroconf
      smartinspect
    ];

    pythonImportsCheck = [
      "spotifywebapipython"
    ];

    meta = {
      license = lib.licenses.mit;
      homepage = "https://github.com/thlucas1/SpotifyWebApiPython";
      description = ''
        A Spotify Web Api Client for Python.
      '';
    };
  }

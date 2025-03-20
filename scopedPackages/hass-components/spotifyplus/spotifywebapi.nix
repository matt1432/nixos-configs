{
  # nix build inputs
  lib,
  spotifywebapi-src,
  # deps
  python3Packages,
  ...
}: let
  inherit (builtins) elemAt head readFile split;
  tag = head (split "\"" (elemAt (split "VERSION:str = \"" (readFile "${spotifywebapi-src}/spotifywebapipython/const.py")) 2));
in
  python3Packages.buildPythonPackage {
    pname = "spotifywebapiPython";
    version = "${tag}+${spotifywebapi-src.shortRev}";
    pyproject = true;

    src = spotifywebapi-src;

    propagatedBuildInputs = with python3Packages; [
      lxml
      oauthlib
      platformdirs
      pychromecast
      pyotp
      requests
      requests_oauthlib
      setuptools
      soco
      urllib3
      zeroconf
      smartinspect # overridden in python3Packages
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

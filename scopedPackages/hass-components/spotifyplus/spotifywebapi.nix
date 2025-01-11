{
  spotifywebapi-src,
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
      requests
      requests_oauthlib
      setuptools
      urllib3
      zeroconf
      smartinspect # overridden in python3Packages
    ];

    pythonImportsCheck = [
      "spotifywebapipython"
    ];
  }

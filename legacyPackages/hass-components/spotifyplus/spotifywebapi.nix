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

    src = spotifywebapi-src;

    # FIXME: https://github.com/thlucas1/SpotifyWebApiPython/issues/1
    patchPhase = ''
      substituteInPlace ./setup.py --replace-warn \
          "docspdoc/build/spotifywebapiPython/" \
          "docspdoc/build/spotifywebapipython/"
    '';

    propagatedBuildInputs = with python3Packages; [
      lxml
      oauthlib
      platformdirs
      requests
      requests_oauthlib
      urllib3
      zeroconf
      smartinspect # overridden in this python3Packages
    ];

    pythonImportsCheck = [
      "spotifywebapipython"
    ];
  }
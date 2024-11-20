{
  smartinspect-src,
  python3Packages,
  ...
}: let
  inherit (builtins) elemAt head readFile split;
  tag = head (split "\"" (elemAt (split "VERSION:str = \"" (readFile "${smartinspect-src}/smartinspectpython/siconst.py")) 2));
in
  python3Packages.buildPythonPackage {
    pname = "smartinspectPython";
    version = "${tag}+${smartinspect-src.shortRev}";

    src = smartinspect-src;

    propagatedBuildInputs = with python3Packages; [
      pycryptodome
      watchdog
    ];

    pythonImportsCheck = [
      "smartinspectpython"
    ];
  }

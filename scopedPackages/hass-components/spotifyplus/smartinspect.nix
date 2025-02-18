{
  # nix build inputs
  lib,
  smartinspect-src,
  # deps
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

    meta = {
      license = lib.licenses.bsd2;
      homepage = "https://github.com/thlucas1/SmartInspectPython";
      description = ''
        Provides Python code execution tracing and diagnostics support via the
        SmartInspect Console Viewer.
      '';
    };
  }

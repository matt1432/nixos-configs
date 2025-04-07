{
  # nix build inputs
  lib,
  buildPythonPackage,
  smartinspect-src,
  # deps
  pycryptodome,
  watchdog,
  ...
}: let
  inherit (builtins) elemAt head readFile split;
  tag = head (split "\"" (elemAt (split "VERSION:str = \"" (readFile "${smartinspect-src}/smartinspectpython/siconst.py")) 2));
in
  buildPythonPackage {
    pname = "smartinspectPython";
    version = "${tag}+${smartinspect-src.shortRev}";

    src = smartinspect-src;

    dependencies = [
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

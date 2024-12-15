{
  fetchurl,
  python3Packages,
  ...
}:
python3Packages.buildPythonApplication {
  pname = "tflite-runtime";
  format = "wheel";
  version = "2.14.0";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/8f/a6/02d68cb62cd221589a0ff055073251d883936237c9c990e34a1d7cecd06f/tflite_runtime-2.14.0-cp311-cp311-manylinux2014_x86_64.whl";
    hash = "sha256-GVq3UuflcymmjlTdPdVDn62Ii5v/G+Dw3AQqMjepDk0=";
  };
}

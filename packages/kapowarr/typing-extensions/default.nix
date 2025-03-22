{
  # nix build inputs
  buildPythonPackage,
  fetchPypi,
  # deps
  flit-core,
  ...
}: let
  pname = "typing_extensions";
  version = "4.12.2";
in
  buildPythonPackage {
    inherit pname version;
    format = "pyproject";

    build-system = [flit-core];
    dependencies = [flit-core];

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-Gn6tVcflWd1N7ohW46iLQSJav+HOjfV7fBORX+Eh/7g=";
    };
  }

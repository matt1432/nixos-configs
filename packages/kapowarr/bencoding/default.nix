{
  # nix build inputs
  buildPythonPackage,
  fetchPypi,
  ...
}: let
  pname = "bencoding";
  version = "0.2.6";
in
  buildPythonPackage {
    inherit pname version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-Q8zjHUhj4p1rxhFVHU6fJlK+KZXp1eFbRtg4PxgNREA=";
    };
  }

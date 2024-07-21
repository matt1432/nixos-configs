with import <nixpkgs> {};
with pkgs.python311Packages;
  buildPythonPackage {
    name = "coloryou";
    src = ./.;
    propagatedBuildInputs = [material-color-utilities utils];
  }

with import <nixpkgs> {};
with pkgs.python311Packages;

buildPythonPackage rec {
  name = "coloryou";
  src = ./.;
  propagatedBuildInputs = [ material-color-utilities utils ];
}

{python3Packages, ...}:
python3Packages.buildPythonPackage {
  pname = "coloryou";
  version = "0.0.1";

  src = ./.;

  propagatedBuildInputs = with python3Packages; [utils material-color-utilities];

  postInstall = ''
    mv -v $out/bin/coloryou.py $out/bin/coloryou
  '';

  meta = {
    description = ''
      Get Material You colors from an image.
    '';
  };
}

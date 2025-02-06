pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:7bf6a672e1743d62002aa518ea880f486f642c238ee93aa6d572f899a05da486";
  hash = "sha256-61DWaiZ61dc8MZAS+N1MM3SiemT6hmbNRvGLxVwPpl0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

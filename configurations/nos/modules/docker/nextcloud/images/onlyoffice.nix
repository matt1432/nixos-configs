pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:93642f434071856d084cf57945626df7b9d5a11576a2b5fe38230b2be98dca9a";
  hash = "sha256-JI2tBKVi0AGhjHdrgsGs3XHBoTH9MLsXoS96CSZCWoY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

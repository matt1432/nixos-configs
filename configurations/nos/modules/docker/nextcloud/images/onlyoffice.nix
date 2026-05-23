pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:e3da62a847b9a5d51a11f73cfea1d9c13c3be3809614490d4edddcf01dcf919b";
  hash = "sha256-au1soX0OxSdpZVtn8k8LgFVKT/+jtwCMjduj3bdsLPA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

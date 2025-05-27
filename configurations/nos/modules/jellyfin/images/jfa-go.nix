pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:309034846723832a2dd8d2384a31b51239011af571353a1ffc2daaa8c381a943";
  hash = "sha256-hNEulEEJBWc+X9t10ypVf6QliM1TCEraGA6568EMwts=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}

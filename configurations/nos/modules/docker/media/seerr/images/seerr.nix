pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/seerr-team/seerr";
  imageDigest = "sha256:aadee014b40e28cf9aa4928bc9d1183a6eb08f8c44d543cddc9efdcb16549be2";
  hash = "sha256-gkHmrUyz4Jq9CAeWsQgBw7lAuIc2NEU627Ef9Rxk8jc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

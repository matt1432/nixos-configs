pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/browserless/chromium";
  imageDigest = "sha256:664e082b97dcd423fd88f66c58fd77ed575496a3e8b6964e0c4c5eeafefe56e7";
  hash = "sha256-ij+M0ZNLX/fXDJTPcmB4lDloiFfMLXrfJO84b3K4Q9A=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

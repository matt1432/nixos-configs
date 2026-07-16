pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:fa25dc4482506b0786a17a167b25348e6ca303ae0213404416db35441c75af29";
  hash = "sha256-uNS83tuanCP3xB+W0iN51CkKO3oGazT85oR0kyI72O8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

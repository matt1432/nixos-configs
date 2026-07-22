pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:5a88c9c45479443d7be2eadc894b4ed0a9801bae03d97a5760ae13b5c2005942";
  hash = "sha256-uNS83tuanCP3xB+W0iN51CkKO3oGazT85oR0kyI72O8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

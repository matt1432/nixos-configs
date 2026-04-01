pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/browserless/chromium";
  imageDigest = "sha256:7ac66e78ad0c99ca2e190784c34155ed697ed3b1ac8b697cabd8607c231a212c";
  hash = "sha256-0gIRdEVOOsrHHDesLfZinv+aX/b6GSOnBRXFrDqzSyA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

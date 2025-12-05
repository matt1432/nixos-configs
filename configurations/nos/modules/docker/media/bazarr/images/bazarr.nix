pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:ec11e988e8e13411c994a4d9f43ed9b97409aa92c1da54d9f23926c3da7c2032";
  hash = "sha256-kbT4dxDFdKADJNbYMei4A+36DMCOQge5rLsFZXX+/e8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

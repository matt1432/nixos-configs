pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/browserless/chromium";
  imageDigest = "sha256:e1fd9b7987f5bd2e400729ba49964e5d078a68fb331461cc8b2140cd3f7380ee";
  hash = "sha256-iLZ2yg6Mgku9XeQwE/guNpmLVIPmCRyakG63SznmsKc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

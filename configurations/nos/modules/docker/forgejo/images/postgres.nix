pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:9e279cc7fc6e908da071befe389c576bd6752dbd295a9c078f96a75bab03e54c";
  hash = "sha256-iN+1g6LLpsemgtqVHlER1A4e/G0KFZygShHWpUAkVoU=";
  finalImageName = imageName;
  finalImageTag = "14";
}

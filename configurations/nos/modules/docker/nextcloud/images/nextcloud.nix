pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:2fd52490cc854b728f47327654d9954b0d5d8d29cb9ad79dc17c4ef42e57e89c";
  hash = "sha256-qupcAMV1Yw3J8Ebp8+IZoP2e7Cx5C/8AEQV2piFPGUg=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

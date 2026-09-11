pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:05b8cb60c354a44ab824ea6e7dc69b46d50762cdbe728a347a5b656e6fb3d7c4";
  hash = "sha256-Nxj5XGQHOCfO31HsOeUV1zQxQMLLXHIKo2RWWeTVOBE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

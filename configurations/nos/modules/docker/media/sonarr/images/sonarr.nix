pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:339814bbf50599ac3b59077c252f29833d0138b59a062d0e82ce37bdc7f04f86";
  hash = "sha256-HlzQv0KP9FEBLTNzpmJJCIMdSY2iVA75RA3Sq22PH8U=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

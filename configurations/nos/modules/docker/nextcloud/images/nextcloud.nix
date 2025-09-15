pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:5ff431abb2cda9da98c1b2d4c4cbbd3c2ebb89a0595fe38c24050c6193be8a28";
  hash = "sha256-tceKlF20HtJUotaQkqmim+NxNjIRYfGjnjVlkP6JnHg=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

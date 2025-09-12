pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:c495ea3af39d1f8b43044c6b7bdb46dd703ef7f2c681e25f6a7270f83eadbdd2";
  hash = "sha256-tceKlF20HtJUotaQkqmim+NxNjIRYfGjnjVlkP6JnHg=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

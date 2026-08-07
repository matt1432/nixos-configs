pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:d36e713e8f89483af1ab0d72011bbd503f5ab100b68ccbfad51c39e3f0a0567d";
  hash = "sha256-rYEFSlGnsbUEL3VEaDHRkix5YIPj+iCmcM5HHO0GdcI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

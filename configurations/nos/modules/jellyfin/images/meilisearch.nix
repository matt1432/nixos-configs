pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:4931c0afd68b12d3db4a608268c6785bba26d3f3b43a228eff62ec38d5a47d8d";
  hash = "sha256-RpTf1shjPam7Gug/3gqYNIcR0qT0kS5mOfSKF8g/hO8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

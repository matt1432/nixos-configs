pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:91bf09897482c17205c8faeca8daa8d57999fb9de20d862763cdfa92ba4ec790";
  hash = "sha256-v1ttfzRfuIYtsLAnsqNUzvHaLiEV4VZKZLouXTLCfq8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

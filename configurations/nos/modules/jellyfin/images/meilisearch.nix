pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:7cd29dc6886cb97475137471668033affb3442bdf9bdad5eedbbfb5189dbf5bc";
  hash = "sha256-WXra6sKE2T3BZ8a+xgyvigFqD+YzTMc18hY6a9gCHjs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

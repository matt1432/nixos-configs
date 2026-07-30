pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:27d144e0722719ed8c5c6da82297b96d3d3bdaa20803b41d9ba5087da99494d6";
  hash = "sha256-dQSIsxELoLEMQkbjsuKRj3Fxb0osuqs+u6dpZW/8LLM=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

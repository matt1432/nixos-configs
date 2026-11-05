pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:e1981983b1c13f6024b57d72e7ecae3342eed1581201ab09fb248932d86c593a";
  hash = "sha256-H8PG5lS7IUtXxYFmHgXJzHyyb76SfIhgVZNGySrbQPQ=";
  finalImageName = imageName;
  finalImageTag = "release";
}

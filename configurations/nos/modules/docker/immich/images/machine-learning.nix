pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:ef517c041fa4a6a84a6c3c4f88a1124058e686c9c92bf09a973e7e60c3c3ea1e";
  hash = "sha256-9Y8ysLUMcHWRQRS/ggdQ1Db7THDC63zryomdSm9ps2I=";
  finalImageName = imageName;
  finalImageTag = "release";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/postgres";
  imageDigest = "sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23";
  hash = "sha256-YNxadMZRLd2Wky6UvZFTcJ+KXFxg51E4zPdEAG7HtPk=";
  finalImageName = imageName;
  finalImageTag = "14-vectorchord0.4.3-pgvectors0.2.0";
}

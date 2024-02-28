pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:d00564ed4c14d702b7b4465dad4f4621c2eb985a21758b27d20c673b9fc3ebd4";
  sha256 = "17d2fcmb47ijrc96y55fihjjb2dsj9jjhjn4kyacdi5g4x5aanz7";
  finalImageName = "postgres";
  finalImageTag = "15-alpine";
}

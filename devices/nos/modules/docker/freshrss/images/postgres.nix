pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:e7d3e4fdcdb4187649d50217c3a8fed20bee215cd19233004c9fb0eaeae5ecf0";
  sha256 = "01zybz808fxx1k74qji09ni5kpw7bmg95kglfm1cx1294jq1vv7d";
  finalImageName = imageName;
  finalImageTag = "14";
}

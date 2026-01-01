pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:5fd97d3efae5e17da18b5884532f07c411330253e0a864d8895f176ab4ab0f90";
  hash = "sha256-NMMBvTAISIuyN7IaqbJ2y/G68+hYa2imsUI3sSrtIb4=";
  finalImageName = imageName;
  finalImageTag = "14";
}

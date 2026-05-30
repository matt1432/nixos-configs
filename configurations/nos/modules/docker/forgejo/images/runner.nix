pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "data.forgejo.org/forgejo/runner";
  imageDigest = "sha256:379b324d6942824b7487706c0a06be4d63e546c17b62bece4ae18c74364a8fae";
  hash = "sha256-R+heO2nKvhtWs5wkqA6/SoPZZ6Y2WB6/A1bZNz/YAv8=";
  finalImageName = imageName;
  finalImageTag = "12";
}

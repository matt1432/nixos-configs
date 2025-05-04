pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:5581b2188f11ea6693e0dfe3f3c3198bb605b78088ec685ad579a5a308cc0d5d";
  hash = "sha256-kMdxcaHL9jp0VkSTNwJ3JuRXopNqr/76klTEf0gdDMM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

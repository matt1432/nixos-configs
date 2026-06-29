pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:3e7dd0bfd7bfb4fc1278d1a354da44375dfe924bed8eaf83ae14967d84dede5b";
  hash = "sha256-RY3vD6cHb7vEoz9VK8SR+m9PEdlanuAfH9CmcfAUD+Y=";
  finalImageName = imageName;
  finalImageTag = "14";
}

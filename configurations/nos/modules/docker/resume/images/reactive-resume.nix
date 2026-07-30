pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:c7b71100d1c77f6cf42cedbd30f4c0ea246a483bb0b356eb9c117ef566886e8c";
  hash = "sha256-Tx7ek8se4iDZrZOiuA6oaWcS3ZbQesdVlFFTeNaw9ls=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

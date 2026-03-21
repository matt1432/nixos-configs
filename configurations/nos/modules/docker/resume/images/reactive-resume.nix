pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:8d28965495714e176e8647935e51d552f141075c64c0adf5b457a407b71e7b80";
  hash = "sha256-HopVC/O3Q7GCi+sS2BwLQGyfoitBJ4yKjwQ0h/+Mr1w=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

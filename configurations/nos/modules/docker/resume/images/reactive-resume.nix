pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:ff5d74fed8f8611b3e3182b9420b6b6ed7020aa39db9b5f8e9d8fb090a9374e9";
  hash = "sha256-JCCQ7K4Zu/3zNqf6tRX1z0F9RdgCuNXjzodSz7GhZxk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

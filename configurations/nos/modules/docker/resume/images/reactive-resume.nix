pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:c487ec5edcfe054bcb312fcd498f868e56f274756d0046b01c83f210855017ab";
  hash = "sha256-Xw6hdc4mucIyedTHqijLOPFqsrOv7UE69yWjdgNvZ04=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

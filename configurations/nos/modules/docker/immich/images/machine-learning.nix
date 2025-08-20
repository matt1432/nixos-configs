pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:f34e855424fd91c5990132e5b2bde91e1d178ec5205de293ebd8779839a4a77c";
  hash = "sha256-AJL4zV3c5oaKnrZo4O3wspd7Oz2+kwfLLnVq8ok9oYk=";
  finalImageName = imageName;
  finalImageTag = "release";
}

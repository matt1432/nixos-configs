pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:a8fe7b9c502f979146b6d0f22438b825c38e068241bb8a708c473062dffdbb03";
  hash = "sha256-uOV1BiLKQex+kIc6nTwQvyHiCEgX0BQ2HmD/jCP20cQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

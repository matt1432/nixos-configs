pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:2b2c1c05eb3f648d2c80dfab9486147dd7bb0ad4d77fa972fc1c5de8f1da3738";
  hash = "sha256-Ea91+fXG6ChwQ5FaUQp9tEXJBQDjG2Q878RSge01qn0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:4afcb099e40ef263a7327f1ee9a870a510a516f872ae79b863c11b94d0b9ebb7";
  hash = "sha256-U4cV1IHJqi/gABRIhacTt3B5xuWRs4+GUqLSFe/Hw+Q=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

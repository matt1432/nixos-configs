pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:80242140e786c1c73d867e8c84bba16c0ebd20cd27a5c6cf69196168b3fe5e35";
  hash = "sha256-Ur7RVoZylK7O8kqBd83FGmSO/lkspCsFrQ8rnmIqOYM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

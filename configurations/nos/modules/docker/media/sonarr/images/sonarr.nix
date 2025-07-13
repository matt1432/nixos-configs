pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:b0ac15772c04f329964ed79cb446ab23fd1ee28f33b58b10f0264feac17d33cd";
  hash = "sha256-d6edfS2HOkxdQGQusEJzYe83yGM5ZsXX60bTXgRYtUg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

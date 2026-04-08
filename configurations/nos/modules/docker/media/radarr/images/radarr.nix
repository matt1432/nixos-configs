pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:cd70546fc97169788530386b42cf47ba1b16d091b4dc2264cd54099dd13c6f7f";
  hash = "sha256-dcbYFQwn6t7ouqQCCi/VPlHu2QCELCsZQv3l5Bcm3Qw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

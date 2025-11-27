pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:475853535de3de8441b87c1457c30f2e695f4831228b12b6b7274e9da409d874";
  hash = "sha256-hRzPqGU3POqgiR/ws12UCk1rlLdzjKQYcwJ1MNMyRl8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

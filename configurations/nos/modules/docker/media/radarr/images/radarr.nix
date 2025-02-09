pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:f4c9c64c42e84a3c03590afd9da2e420c69b5e936b4549778c5d4c00d907ba33";
  hash = "sha256-PWbGdpVZnphW5zk9IZMmI6iXfM/rzR++8dlgxWc/uQc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

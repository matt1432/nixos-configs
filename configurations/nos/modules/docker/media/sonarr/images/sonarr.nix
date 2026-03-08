pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:21c1c3d52248589bb064f5adafec18cad45812d7a01d317472955eef051e619b";
  hash = "sha256-Iz/HMwsWgDQcwLIbIbz1hQNdou3SUL3qy5BiX3wX2d4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

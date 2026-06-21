pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:abbf2aeeb58b641977a012d0ab69939eb277cb827078450b142f782b1cd6893c";
  hash = "sha256-MbmMLZkdAD1FjpU03OMmIuF+5xDUuLwdzKVzR7DawdE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

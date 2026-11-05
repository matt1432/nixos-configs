pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:05c1454f9a32967affc1f34f67f8cc0cc57dd805dca45489fe797095a6286556";
  hash = "sha256-E61TOXA6ZPFkO9iNa0ha5cECPUhHaJ3DUBAt21m/cOI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

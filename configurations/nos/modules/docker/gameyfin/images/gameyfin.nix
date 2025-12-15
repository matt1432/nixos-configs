pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/gameyfin/gameyfin";
  imageDigest = "sha256:e46e75b94878e887e4afd1d4e9d710aa6e17e61e92607d1843bf385b9a896fcd";
  hash = "sha256-hL4uXZRTBjBYDvJFk6/KBJW81YZUXOCNpnBIJ1NRO4A=";
  finalImageName = imageName;
  finalImageTag = "2";
}

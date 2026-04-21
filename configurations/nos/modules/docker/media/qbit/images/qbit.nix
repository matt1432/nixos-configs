pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:8f7a1da9644340c737e3211ecc910a416d4295076e6b2824a4afcd1f4e3576e2";
  hash = "sha256-OV7F3xf+NrMO4DDoojsrzafrDvHhLleJDuvzdExKDLA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

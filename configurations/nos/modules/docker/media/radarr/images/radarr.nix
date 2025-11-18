pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:e26fbfd3782520c0bb820666f041ca056acfe187a8b95214ee1f47512cc05a29";
  hash = "sha256-jwDF8yETnAQCO65XbI/KxT9spOpVUXW++/e4LYPQLTw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

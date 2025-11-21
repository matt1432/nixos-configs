pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/gameyfin/gameyfin";
  imageDigest = "sha256:f4beac2eca52c0fcb3948bb26bec5c9129379f592c7466367c3eff9731d3998e";
  hash = "sha256-JSVK6CMqzyg5F+Nn/eUljkfYp6hKnlvG4Meay6qyT38=";
  finalImageName = imageName;
  finalImageTag = "2";
}

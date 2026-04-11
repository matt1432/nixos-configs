pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:6854df9de20b8c82e1982604f39473d64dbb4c4584b1013f18f9ade1ee92af13";
  hash = "sha256-bT0oO8L2V8Phu35IGjw1xP1eSJyqKJmH6xosXSVlM14=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

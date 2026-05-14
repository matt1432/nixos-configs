pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:a89f252d6a22bd25af14a5380aec0adcc3c3af2e3282164f981680e6844070f3";
  hash = "sha256-BpvIYrkYWLm2dJ0haSTJz7mIHA+m9lGAqLDQxEVpPps=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

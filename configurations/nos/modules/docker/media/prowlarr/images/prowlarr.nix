pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:1a6cdd0cc2350f8527dab39bc8467c9a2553bbbcf75a2c66f882fc53d73d5deb";
  hash = "sha256-syezQeHY+36bAmB2UVVBl8qlnZC7l6/ia6bDpFCHZRs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:764b0b8d2990d602c583663a67c8655312e0416397f0ca00f26625b4a3b10a60";
  hash = "sha256-m5QgiH5euosHd7FZbGigIvA3n2AJHiSDLgmUHpobhRI=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

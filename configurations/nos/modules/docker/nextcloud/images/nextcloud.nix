pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:85b223e81f87ed79b0974532f694e2297e3ab372c6b858fe1848b3955747b08a";
  hash = "sha256-ea1KU2VBJEvsQV1AiVzeXdksVT7eEtJyRPOySWhxXm8=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

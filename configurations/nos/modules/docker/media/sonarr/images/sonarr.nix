pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:60f3b6b5c7647ba2bafd81163acfe34b11117b9b834ebd7fbcc3e5f1b309c7ef";
  hash = "sha256-Dl1NYPWtlOTKeSKmjWGR5Fz5E78y9d548OP3BaETgT8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

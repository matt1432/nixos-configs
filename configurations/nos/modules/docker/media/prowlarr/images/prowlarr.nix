pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:e3242cf552ed1818f9e8208c7826e6b3a28b9203c9732fb0dae176b0323954f2";
  hash = "sha256-kdRtOAmw0OBLSEqurQzEkp9bqAL5qjMT1i5kDvE9R80=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:4b52038b7b6452a20c145239fa07d8218d1541d736a96c43aa0a5f60141cab28";
  hash = "sha256-3qIgegPk/euXgLD8G5A+eNcUgt2i5DhoA3/UKke7/v8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

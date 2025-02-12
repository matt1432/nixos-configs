pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:8883bf1c8afdd45dfb8146041d944656efac01208ef44b7bbdd2aa8b0fbc1782";
  hash = "sha256-Fo+50jcu+ihfR2dU6pSm85f6cwgtegw/LID1Qcdnioc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

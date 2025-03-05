pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:7122354defac839a7ecf541395907c21805f6a2b60b67ee476e66b162f1a355d";
  hash = "sha256-xcFmtb8GRAc2VQnPjytIh1Pmof3njCDWFoF233/upx8=";
  finalImageName = imageName;
  finalImageTag = "release";
}

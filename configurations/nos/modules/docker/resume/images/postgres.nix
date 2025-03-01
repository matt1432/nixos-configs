pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:ef9d1517df69c4d27dbb9ddcec14f431a2442628603f4e9daa429b92ae6c3cd1";
  hash = "sha256-qrYC2YmySd6lNiw2fsd3MFf5npg4/xgkyiT/Ty3g4ZE=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}

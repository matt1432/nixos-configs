pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:6779d7a308f3c9c518a644ad9326be6149dc50352c91927725936a1115e09b0d";
  sha256 = "1qckzi60db6q3dw61qqpfj4xsf7fa92aaf5x7ra2ac5sm1kbhl3x";
  finalImageName = "postgres";
  finalImageTag = "14";
}

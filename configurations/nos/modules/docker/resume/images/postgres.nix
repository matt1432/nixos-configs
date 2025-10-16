pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:7898d413578ff5fa67ce49233cc9743e282010eb2ec6ebf7834a63f4a60b05f0";
  hash = "sha256-neAQQa92onE6d43OqSSpCBmLA1q5Mykydp1mRFiHPHI=";
  finalImageName = imageName;
  finalImageTag = "16-alpine";
}

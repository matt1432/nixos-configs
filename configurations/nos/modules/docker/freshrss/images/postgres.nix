pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:f7b28597c837f7b83adf763cdb128a0e7f5ddcfe87ad154f69967b1f92781e04";
  hash = "sha256-F0XgrzL8h62xWXnH5PouwFOv8HVtp9hXYcQRMKDNyGk=";
  finalImageName = imageName;
  finalImageTag = "14";
}

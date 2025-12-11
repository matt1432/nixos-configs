pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:da076311f78c56e4bf6548ef3668fa77fa2865c5efca3f79a6d6bb9b3710b477";
  hash = "sha256-/LbYgLwwIJ0ctEkRKmHRD7hRsARLQmtHD1WfpHuLPh8=";
  finalImageName = imageName;
  finalImageTag = "14";
}

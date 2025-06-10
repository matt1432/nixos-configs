pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:4237609157fa8697e8e7b0e979e099903121d8dc2b6331a088410a4505c6a096";
  hash = "sha256-gMGE4OkQkn/44wpRq1opH9UfRjZ0L/MSP2aX2108Yxw=";
  finalImageName = imageName;
  finalImageTag = "14";
}

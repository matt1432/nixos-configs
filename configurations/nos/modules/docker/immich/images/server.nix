pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:f86bb84d16bfa3364cad05529b903844c3c4da6f558a8fe4fe97ef6f152ca422";
  hash = "sha256-rnoBOzFTsXcjhHFe0rsQ5rOfZurBtTm4llngpR1fWTg=";
  finalImageName = imageName;
  finalImageTag = "release";
}

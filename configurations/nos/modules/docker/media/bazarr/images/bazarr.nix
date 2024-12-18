pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:a602332403fcac11717c37ba14fb1852eb0b752d95db67915914fc9dd9e653a8";
  hash = "sha256-iCFYql/wrNS/8JResJ4Gpi0K+Tx5/Ku45qBpHgamkEo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

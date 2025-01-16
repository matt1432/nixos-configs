pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:7fe0928f6de61208d6b39730456085d74578046df4c684fa198f0fb065f4381e";
  hash = "sha256-tE1HB3dHqRzwOkvKx7ZKfmyAm9UoMrP0x+DQOIwUQBE=";
  finalImageName = imageName;
  finalImageTag = "14";
}

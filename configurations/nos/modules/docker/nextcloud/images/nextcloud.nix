pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:6fddfda183d06f966014c2bb80d972596ba1b20464db756e8b33695c57029a60";
  hash = "sha256-ejleIdAgxWgLLGl+6sZ7YQ0gcGn61w1yn9P8rPezQ20=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

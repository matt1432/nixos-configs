pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:e04697675c1bdbaf6fec1fa81ad37b462a579ccc17bbd4f6315021ae6ab99ae5";
  hash = "sha256-AgjBFaZwy8aDyqrCLiPNRJtIZGjimhmfcnbyiuRTZIg=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

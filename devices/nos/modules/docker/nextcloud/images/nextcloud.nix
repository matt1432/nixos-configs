pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:e364690143d6114ffe268eb81b8905680e3ff561ac00267928f156af6f4fe571";
  sha256 = "17dra0nb097vjvwy2h2ycrxkw904arhkqjqk6ndgg7jm57g5rxjv";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

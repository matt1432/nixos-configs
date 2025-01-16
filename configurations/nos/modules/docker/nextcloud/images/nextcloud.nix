pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:4f6026de2b9cf007bcd01298a86cae2fd5837cbef9d8aa3224454ff80ecac577";
  hash = "sha256-Urcuc1xkwDeJo9BjRT9vz3wMr/v/Lfn7o11HALowuKU=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

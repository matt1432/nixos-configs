pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:b1c48d06e39ac572083f7279ed711506d997bcd7a11a3705cb54a0d16e7feac4";
  hash = "sha256-Urcuc1xkwDeJo9BjRT9vz3wMr/v/Lfn7o11HALowuKU=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

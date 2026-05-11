pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:d96341058d8026dbe7c97d7f262272bc421efaf88438b2676ea20ce3293af423";
  hash = "sha256-rjitUtHzsvzX+X7jXzPBvKyxdY8FRrDfN6KPmpXhzuo=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

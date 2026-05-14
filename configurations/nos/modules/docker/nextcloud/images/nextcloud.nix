pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:6d730635a2d223a75d955b33510dfc84eb7f25a0c737f973a54dea041317ab80";
  hash = "sha256-rjitUtHzsvzX+X7jXzPBvKyxdY8FRrDfN6KPmpXhzuo=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

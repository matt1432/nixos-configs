pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:37e8e537f4368a07d893a24c0d35ae2d508973208757f5aa2ba2c2d5999c84de";
  hash = "sha256-ygT4tuBTxa54WlPf14ws+ownzsSv/wwnLXdpV6XRk+4=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

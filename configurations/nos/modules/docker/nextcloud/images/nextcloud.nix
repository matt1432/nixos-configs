pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:f277ddde7210f04a47daca3c3a0a6f42ff801c1e31b1f883b0a60feb842ee1d0";
  hash = "sha256-FLPzypD/AAjBYK0mhJWcFjtJTMHcS8fo9h0nJYd66gs=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

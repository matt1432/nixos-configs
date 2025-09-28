pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:e2d5ea25d0aa53a3bb22e7fa537f40f8246e1d9ce8cd825891a9a8ada24188b0";
  hash = "sha256-g22mOtX96BYiMq7+S0F9OAvHH8n+C0iVZg9PHe4Ruq0=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

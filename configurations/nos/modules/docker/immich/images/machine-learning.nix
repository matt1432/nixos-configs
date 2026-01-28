pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:5fee7f3e052c3d32d4edecafad68317394daae26f57d895fbd487886083725a7";
  hash = "sha256-WsPYtXgHjJIlTCSHO18twF8WBH/5CTenNNnDlcJGHOM=";
  finalImageName = imageName;
  finalImageTag = "release";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:24bfef29bc5c0923c64c98810931eda1449a4b237e6704a715605761bc107ae4";
  hash = "sha256-/RrEKyHP90K59K9+lYJYddxtgpI9QUxlbnTrm+xtZZc=";
  finalImageName = imageName;
  finalImageTag = "release";
}

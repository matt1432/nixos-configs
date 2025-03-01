pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:8011358f5bd474d72b08a9dc1ad38f4c763ef0e4ebbc6012fd6141801268f141";
  hash = "sha256-CvZFzAfzrxP+JslOEKRRgnY89Yi26C6G7XATUGd5N5c=";
  finalImageName = imageName;
  finalImageTag = "release";
}

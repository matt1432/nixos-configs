pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:db61408634e608dde65ecda5b9d9cc8c20948d0e7b78b660bf33b3c526b6c1fd";
  hash = "sha256-c+yZWyrCcdQNc8tjEQZrgCVUulvgrg+4al8qPhBYqNs=";
  finalImageName = imageName;
  finalImageTag = "release";
}

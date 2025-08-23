pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:735cacb990861a2e8e69ee71389d5551d4ca1db426b330c7c5a83ab28901b3b0";
  hash = "sha256-bXRZocId/JZCkXrQpOuqU1dFphYEkuYvBKx3vM17DMs=";
  finalImageName = imageName;
  finalImageTag = "release";
}

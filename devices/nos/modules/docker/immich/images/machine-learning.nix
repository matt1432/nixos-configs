pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:66f13f7fb1af555f9f1767c3dd5d404b7e5f486a272dc73af9e6480f541463dc";
  sha256 = "1i9i658b5k00r770f9ddbynz5jfgp9mql5z8ccdbld1fvl20493r";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.115.0";
}

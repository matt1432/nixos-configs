pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:c9d751b5a0c1cb8e2e32aee9a983c811a439f0ab13582c6bdd13d93f86a61954";
  hash = "sha256-b70rf3zEoYcCEudsmX0kqqZq3WhWmyd3OLQSyOB9myM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

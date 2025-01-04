pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:a324fa4d81cce73116801bee3c50b632f3457c0ca0ad31aa692c640e22f50dea";
  hash = "sha256-AmmNSrpzNQ1bb2Jh5dSBFZhBpuc5lOzoJiVEkLZpvGY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

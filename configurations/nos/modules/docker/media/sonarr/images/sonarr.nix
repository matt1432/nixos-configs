pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:48e36b608b461273b9dae857725cd0561a127f2c694b687318f6d0c5ce63e5c9";
  hash = "sha256-dpSR9aBxp6Dh7Ajaz0NRqQv25L9olSMhN0/bDVwFyPk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

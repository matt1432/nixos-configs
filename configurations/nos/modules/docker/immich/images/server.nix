pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:6606ce7740f7a06f7a53b49083100c6c05f75c84c85a87e9e4e7309ac0c5d454";
  hash = "sha256-iULntuPVct7nWMfot0+18VBQ8rvdihDdy/Q2/s7kYWk=";
  finalImageName = imageName;
  finalImageTag = "release";
}

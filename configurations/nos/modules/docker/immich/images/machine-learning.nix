pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:2f381909ca2b669f22bf872ee0bea6b7d16dfce109431647a8cad0f2571ff053";
  hash = "sha256-ZZPQKdpEteGqLxs7lHLDcYgmKlSx6mHGyaExhtmPnyY=";
  finalImageName = imageName;
  finalImageTag = "release";
}

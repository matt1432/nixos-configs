pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:0cc1f82953d9598eb9e9dd11cbde1f50fe54f9c46c4506b089e8ad7bfc9d1f0c";
  hash = "sha256-skR8wNHZkgY+9PmwnQr8Y4KoFBgreOR5X0ITA7nkO3k=";
  finalImageName = imageName;
  finalImageTag = "release";
}

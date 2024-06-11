pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:b29d17de30931f22719f0ee39dd7bd24e2f6be08e61c13bd881e41ed426087f2";
  sha256 = "05yl9js445cdz31p5rp2clvvwpks7rpabpk9n4sg5d7ijqrnbi3p";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.106.1";
}

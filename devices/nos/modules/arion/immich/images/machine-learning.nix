pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:ed3ef285ccca49e4bce2b64f812c012a165a2dba87875823a09aa36c2ff183a6";
  sha256 = "0i2d025ychpiyvk234hmgm59brk7hd2krvxdpb7nakr1p5q8wxig";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.98.0";
}

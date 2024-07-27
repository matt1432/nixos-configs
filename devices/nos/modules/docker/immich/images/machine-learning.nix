pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:794c3fc4a1da9925f1fdd4ac13fd0646f11a5f682bd50e1cd7e2283f3332ac65";
  sha256 = "02p0acynz8sc78dbm62dnwdd9hjrrd9y82c0zcmy38sbh9s6a3rd";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.110.0";
}

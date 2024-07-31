pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:d4a5db2c7cda2897abea98a3d5fd0c3cc76618fff271708075faeee426fe1b64";
  sha256 = "1rwbp94r8lnb2pv7vam9kkvk0ibv4q8p0qy91q7n243y3bdmhic3";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.111.0";
}

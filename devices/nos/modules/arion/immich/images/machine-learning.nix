pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:9577a58ef2c1b61f6f7d7e8c2d86d2e94facc04d901fb27710cbf92fc5e47bfc";
  sha256 = "04wa6gsazy0qdfalgp0v9danap9pbj8b0mlgz1j9scyh60azql33";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.106.1";
}

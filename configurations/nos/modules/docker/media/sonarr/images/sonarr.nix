pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:76414c033f290d3c9f1f9dfad71150abe71d92592369a3377a5903d579e6e2b2";
  hash = "sha256-Lkr/aRORIj+uFpFWtYzt8SIK8SCd5cfIiudnvbrkF1Q=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

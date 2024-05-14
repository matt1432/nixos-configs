pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:9ea26fed9da394d719ae6790418337510a9c824d0253cbd07d3db70b3aa503be";
  sha256 = "1z3i6xc0134hj3s0gsmfi0xwr1qf8dzk76vq2sbislyz5p8k01fb";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:d758c5a5edc4cda1263260948b3f460f511430bccea505dca3cb70af01332ff8";
  sha256 = "08q1fi21l3m0nsdncwc19qi3vgpzgswr2581x6a8kj9c3s1yh057";
  finalImageName = imageName;
  finalImageTag = "latest";
}

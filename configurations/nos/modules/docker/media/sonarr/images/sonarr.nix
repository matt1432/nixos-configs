pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:4d9df314875e1249ab7d6170c2b9b3dc1d8e6383f168ceb10dc9a5ad9b324739";
  hash = "sha256-1VzYB5HR3jRH6NzRTDzqQcUYzbteiQXpOFwZDZ06MzM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

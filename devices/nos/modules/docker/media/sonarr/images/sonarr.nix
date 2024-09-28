pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:12570fbaddc8733664e1e5d9bb12a719cb07f9455c518097b0e6426f4960f884";
  sha256 = "10f4h2lwdwkpgcz6s855xz69hy74ha2yk6ia7k7gaghsq31cdn5z";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}

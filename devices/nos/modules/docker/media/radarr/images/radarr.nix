pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:df843d96b812d858b94377ffed1918424ece6735038a19e8ff93730277757b65";
  sha256 = "0bmbrn58xkc38fcysd9pqg6jwjzd5w5msdb6nh9j9h3g09ivi303";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}

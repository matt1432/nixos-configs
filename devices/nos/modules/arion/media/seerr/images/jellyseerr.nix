pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:056117f4bef8b89788f42c6ed6d3ea21509b027e2b505eff2c7450dba1c88f1a";
  sha256 = "0a7pgfpy1wv177w53dv43hs7ll8gzb09klmdpszfjpa8hpa7r8wp";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}

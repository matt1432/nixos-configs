pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:782a911f0f3e9ad3a9cf39292e1d43b8a184cb989d7edc4abc8d8480b221b5aa";
  sha256 = "0sdb3sj5pv7lc655n825z11hz8dp2hv5sx1049yn0l8wlljczwf5";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}

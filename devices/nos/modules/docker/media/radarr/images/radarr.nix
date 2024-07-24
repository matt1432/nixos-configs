pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:2a02b311cefb344cd0caf74a443b9d6318daf15bda5280a3bc732381db983dc3";
  sha256 = "11mvmh9nxs03pvrk2zrb9nibsa6vnd7x95qdcaxgiqhvb3ipqhd8";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:9d6f0548fd805edb30108fdd06d0fc5a4436c9bd708b57bd4119d7aefa815fe4";
  sha256 = "06jc6vpbw0cqk6wdqj84bln6xc7qh72bby0xydjmap42lch39lr7";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}

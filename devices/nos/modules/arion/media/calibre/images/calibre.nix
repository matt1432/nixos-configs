pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:f0ea48698961325a542d00c3894e62f5aec405e1ca2736d6dedec9a0d2df4bbc";
  sha256 = "0vbnhidl1bxfkm5xidv577zk61yv92yjnxw86x20193mhkg5cxy1";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}

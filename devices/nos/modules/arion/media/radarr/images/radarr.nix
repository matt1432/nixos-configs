pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:e6bccb9bd69f3dba111716c6789152d5577217adc27f8f96642e511defaefbb6";
  sha256 = "1j5svym7s6b83w6pf12bm0fa3vx10hx47hhfk9ywvji1nz4zj429";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}

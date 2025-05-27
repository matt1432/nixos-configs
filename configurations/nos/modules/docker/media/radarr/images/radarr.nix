pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:36e43720c130ec2d3ed80726d2134af3c6644729f4750abc830fdda7fa71d1e1";
  hash = "sha256-jKUrc1XdkSPzAp661+8c/6z7vYWJC+//HtDVWuAxf1A=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

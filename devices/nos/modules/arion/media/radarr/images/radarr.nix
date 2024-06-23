pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:3e64efcc14f9b21b30e78c39203e754d1d1a897d0f76ffb92450cd5c8ae16c9a";
  sha256 = "04ydrgf7rw91zkb6mmvgxpx2qdj13ipfriy8d9kk84d2dj8ny3fz";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}

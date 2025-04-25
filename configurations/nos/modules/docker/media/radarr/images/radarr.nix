pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:7e9dbd55e29496f66fd8f3e210e5c202c1437ba8f4a748013c6da8ac268a0de1";
  hash = "sha256-5lCeg3RvBuBTzWv7NLVu59DyENr1a+I78fZzb/firvg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

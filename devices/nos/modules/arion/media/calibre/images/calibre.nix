pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:b46b123babe665b68dcc4f679c14b48cb141a5655371d8fff004e41a80a47871";
  sha256 = "025660r9hr0sxxrl8pgabrgbc4vaxpww261hxkkzcykrwlhymg27";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}

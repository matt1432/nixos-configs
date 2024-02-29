pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:d9cb62904760a40ade8642e70be8e78bccfc7b4301d5496626004444f4c32fb9";
  sha256 = "0glgmw3d6i58v9w8dpf46znrzv3zvcn27ffx0wlxagp19bapmnfd";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}

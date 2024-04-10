pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:563a496ca85130962001b1a40bca1d8f8b37fc646d8d4da771c31d8dd20320d2";
  sha256 = "1yi3dc82jvmmy5xhkzyvvzjygmva9lkiz3r139z9dsrkkdicnf5v";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}

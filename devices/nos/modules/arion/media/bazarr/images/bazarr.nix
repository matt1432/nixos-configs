pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:7387c96ca4ee75eb93b198c9fc1b168904f4371e8ab5963604074714f4e0efc6";
  sha256 = "1hmhzn05i8rmjmzsn0ahirjpzjha64pr15ncm56l7gwm98gks6zj";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}

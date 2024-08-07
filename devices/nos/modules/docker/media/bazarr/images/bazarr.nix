pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:4222fa316c51c2d0257384e5562541059698c220abbb00170eb93c3ddfa52d18";
  sha256 = "1z9a5qnafn3w5k2zg1aaad8ksh37y2nh4n3bi0whyy7b86mlj6w2";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}

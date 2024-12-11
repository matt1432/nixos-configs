pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "netdaemon/netdaemon5";
  imageDigest = "sha256:994c88342171457709b201705c5a629d195afdb2e291b324e8e84cfa9057bb9f";
  sha256 = "1bam5rnrdjv0amd4qbn96w2kaspwd1sam19ag16hmmx4mcbzx2y7";
  finalImageName = imageName;
  finalImageTag = "24.50.0";
}

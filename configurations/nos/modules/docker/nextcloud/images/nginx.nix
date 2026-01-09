pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:fa5f6b4cc851e85f8542619dac4f60b1f24681fc7be221d00f4221c4f3b92caa";
  hash = "sha256-9+QoLRzTvBRAn66M0KMd5GnSTjrlc/NLKAMSca9JTIY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

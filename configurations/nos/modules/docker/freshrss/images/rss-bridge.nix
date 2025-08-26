pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:6e1cdb65952c692691fe0fa8670bef73f38939c50059ff16c2cf7f831d4a1695";
  hash = "sha256-DtmQZhnM8v6G0oxScm2xLYY2u4N0ely9p1mtHF3Rkus=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

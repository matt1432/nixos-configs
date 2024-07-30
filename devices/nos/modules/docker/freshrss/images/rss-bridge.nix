pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:5d8906da7276396e077e054eb7e646f4f02d639be60a0b3bded97ec751fc0700";
  sha256 = "0wgj3w5dvhc0xa5p8c6gik0bc1c6q45yy8ngc37rixkyi677qgn0";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}

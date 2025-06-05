pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:9886ec2915a8ec502d4e153a64995e3680f20222698656f0ff832f794b1f706c";
  hash = "sha256-vug7xKpSbgTaHuNSgrv7TO3ajXMbjzyM7swxzG+58DY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

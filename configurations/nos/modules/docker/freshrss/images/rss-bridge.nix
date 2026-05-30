pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:1e20998c4ab6d08c998278926ec139ef7649da7d9ac63229c7ec39ac855d832d";
  hash = "sha256-hqHPwqd0Tchp9s+fiZ6KbmhJPRdpN2F1iMtHlJbCoZQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

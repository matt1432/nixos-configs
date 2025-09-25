pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:432a4bee213ea68c08dc75daeeebc62d9267cf97da4fcb2809a974954600ffcf";
  hash = "sha256-wSVwjM+2XQ+klrSBRdgYeTUqjeUSH8pD6H/PvboJJ6g=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

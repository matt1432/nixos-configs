pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:17f1153c64d56eea234638d991fcfe60ea47cef6d6db0772ef04f010269ec301";
  sha256 = "07vci6fl95rakqadw548bmj7hv7y15sjw5wcw21dlhv0cw37qxm5";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}

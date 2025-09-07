pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:05eda1052c80422413c00c40a307865c4d6b92f97c36e19b39dd3129ecf40187";
  hash = "sha256-VQU5O3uRvx1hasIyWKlQg8R1etWC+IOVDgHUguo/NMM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

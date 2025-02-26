pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:f388549e6c92fd14e5f0fe901c8d05a11fc9acbf0e4d397491355b0fcc84d57b";
  hash = "sha256-qK7qun9QjKAGMOMooipFivefM00or+leBfWOTOey73s=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

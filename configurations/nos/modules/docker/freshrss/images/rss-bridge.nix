pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:e3a36ea2096c03a2afeff4d5dcc278c92e4dcf952e9e223aa3fffcb4cc5842b6";
  hash = "sha256-PDrA+L/+aJv9DSI01QsVT6LkmUAQu98vXraAzsyy6FI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

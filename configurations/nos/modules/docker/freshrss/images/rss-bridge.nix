pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:e850828a43ded9d5084e7f443c26c6090a0c29e0a747f81499ef81924042d960";
  hash = "sha256-KyqVIPXCv8QsIBRPETEpuoxXjPmnFOplM5XH+Q2LLR8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

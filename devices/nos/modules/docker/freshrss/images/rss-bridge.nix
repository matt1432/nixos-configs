pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:d6c6605bbb3c986a505c63625466d7fa00c1a58bf0b1c5d0c923fda0aab340c1";
  sha256 = "132b7v1l6vrdxjvhg42c74y8agpjxcprg7qbl2xjv58hidf7kdp5";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}

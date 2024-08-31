pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:ffc5966ca95af2d031a5c7561d3144454898e330a68862bb0299db6349806c25";
  sha256 = "059qly0brjsh3ch6b2kmsn2rfsvlvayiaqkpiiydr6fyh85ryrvj";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:a869f33f22d10ce04b5efa40efe273f3454dee8113508f64bca18a85b1eff724";
  sha256 = "0bppsqy4wbxbaigsf1i8a5czn8v04wzlwk3kavgfpaqhw0vbcxz3";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}

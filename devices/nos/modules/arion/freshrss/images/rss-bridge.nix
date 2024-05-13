pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:ebc9be9dc5c5dec92e24e36bd343de732618245878cc1ae4e0812338b117e0f2";
  sha256 = "0lc21d36bjs02vpnh53sgachsnan7f9chdym0fh4va4g80wr58xb";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}

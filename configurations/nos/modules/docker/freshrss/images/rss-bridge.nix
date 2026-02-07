pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:d718655c564a412bf6105e389a105319c9452eff5c24c82e0dd7e5c77fe19481";
  hash = "sha256-JztJW33jCJrNbZy0WsjAmohxfi2hbB2rzLLN/IcXlKc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

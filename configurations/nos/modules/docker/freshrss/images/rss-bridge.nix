pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:539383a3c5ee42594fac9cec10da8f9bd36adf5cd415a476a85cd9c36db735a9";
  hash = "sha256-p/OZl9vwgpd1zRiQ49F7mGkdz0/+IPTJ7Eb4g+7jAW4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

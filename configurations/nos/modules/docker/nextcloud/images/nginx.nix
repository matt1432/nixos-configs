pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:124b44bfc9ccd1f3cedf4b592d4d1e8bddb78b51ec2ed5056c52d3692baebc19";
  hash = "sha256-GZA2ZIhDVPgXmJ831Ix16dYK9nGntckNpyS9Md7yrNU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

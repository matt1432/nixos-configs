pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:b0ee2135e6ba52ad3f102aae9663707cd1c9531485117067a380d3b2b6dd991d";
  hash = "sha256-fFkiaKiUZTc5Ae3UeAKFoQ1FgPEx4wa6PeLbkicXG0I=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

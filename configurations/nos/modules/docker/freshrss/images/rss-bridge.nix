pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:432e82149408951fe5865d85726e034e507106208fd13ba44e9fd23facaccbcc";
  hash = "sha256-xUAcKOHVljSPoAnm/opzkgJYdm0jLyCoVNYjNPYIZxM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

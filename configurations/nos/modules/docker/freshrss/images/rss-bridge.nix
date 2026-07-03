pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:831c29238554805c66b3f4eae136b138ae2e9fe191c76e7ba8d3956138e19bf5";
  hash = "sha256-iq4bz+1my6D1qdIIfg6koEc12o/6l/IyCMRxoI7Yflo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

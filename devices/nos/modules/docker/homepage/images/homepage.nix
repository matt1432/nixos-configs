pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/gethomepage/homepage";
  imageDigest = "sha256:e5b2616d17db8961a53c0b7d389d812d31c265d35696d475732f53278c9276f7";
  sha256 = "0bchb0dqa2mrj0crszl4gn4xb8lvyfhzmkjkj4ydahm2zdvzys6n";
  finalImageName = "ghcr.io/gethomepage/homepage";
  finalImageTag = "latest";
}

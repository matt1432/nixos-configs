pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:1a2bb47140dd616774ffe05ea1ea8762e1f1f08e20a35632e1e6539376d44d60";
  sha256 = "12msgcrmwcdik735qy38iqp8k2jxxg2s75vy0cqkw6kjj2kr7x5g";
  finalImageName = "nginx";
  finalImageTag = "latest";
}

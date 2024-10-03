pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:d2eb56950b84efe34f966a2b92efb1a1a2ea53e7e93b94cdf45a27cf3cd47fc0";
  sha256 = "0vzd1mh3z88wgc7cwrb1a7yhjzq0ldrg8rw5d7iak9nxx91p8w6q";
  finalImageName = "nginx";
  finalImageTag = "latest";
}

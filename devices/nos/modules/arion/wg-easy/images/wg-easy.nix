pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/wg-easy/wg-easy";
  imageDigest = "sha256:6fc9a00456237d0f8c39739f7b265e5b804f50d49266d9951580afb953f2e723";
  sha256 = "0clg2y3d0jdhc0lp3k84ipmr06r2k5r469rjg8av56p356pzbp8i";
  finalImageName = "ghcr.io/wg-easy/wg-easy";
  finalImageTag = "latest";
}

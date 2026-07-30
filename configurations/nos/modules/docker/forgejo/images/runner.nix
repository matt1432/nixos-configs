pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "data.forgejo.org/forgejo/runner";
  imageDigest = "sha256:eb6e7bc21973382d261e6eb883dbd27b8cb56939d33a3bfd79a1352b7f9a33a0";
  hash = "sha256-B0MJ9P7YsNZ8HYBhkBsBEqyfLvm4SR/6NVOX5h3LB30=";
  finalImageName = imageName;
  finalImageTag = "12";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:27715a8921343d80e814a96675f63c0494efcae2c5628ba6f88e1626a3eb2fb0";
  sha256 = "0ysycwvrwjzz3mkllcv7h2gjic89bizsz7m2n40bnz7jl8z45bwc";
  finalImageName = imageName;
  finalImageTag = "latest";
}

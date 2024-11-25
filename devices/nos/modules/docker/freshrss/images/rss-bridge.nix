pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:72218407217f2495a5f7f39b0adc1fdefba05c2fdecae6d4df1192389a250426";
  sha256 = "0fid740vph4a4335i2s4ff31hpmv33axm894jm69vdza8jr9fsky";
  finalImageName = imageName;
  finalImageTag = "latest";
}

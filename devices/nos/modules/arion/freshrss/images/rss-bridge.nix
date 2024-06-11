pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:6509181cfc551464580ced84d7bbe87e88435d49dfe2259169080130c889bca8";
  sha256 = "0i5gwgzd2pbfckxnvzcgyn2s7jw24s23fd20a4h30z7kqx06nw68";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}

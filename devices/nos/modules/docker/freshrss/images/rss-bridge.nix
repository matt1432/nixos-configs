pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:b5bdea7965411cb1b3c48120ddda04c1e6218bcbeb201d40d81a18e15fcfef78";
  sha256 = "1w13ri9087vq6yycijvgp24g1qmfal7cg9hj51av905qqlkb8kx2";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}

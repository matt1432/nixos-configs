pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:9e501c795c0e47dffbd81c7a0169b2601582abcadc5d8d415188ab60196b4819";
  sha256 = "0gc8d1hd44k7ib4d8rg8w6qlz5zhjzp8wfn1cfcwbgm883pca808";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}

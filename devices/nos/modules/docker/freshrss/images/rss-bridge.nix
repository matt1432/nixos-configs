pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:94480c924f35512e81ad846fd9968591c63d20221484b7774083055b990ab31f";
  sha256 = "18jakml7v01w4f1y40aflzsnnq5r2pj5wnh1xf2x9c5c5l0nvhfr";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}

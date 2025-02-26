pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:2dab762554578e1b1473af387098e37fb561357c02da886411c01eb0c1ee9a13";
  hash = "sha256-0wAtw1FM20lVFc+Coan/8bEPjoEmeSUOGyJeV8DvMIw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

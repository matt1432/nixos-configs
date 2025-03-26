pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:f699ff53d38c03767c4736fe253b0935c7d6b80725b9f09f2fcfaeac5dceab4b";
  hash = "sha256-ruA7MdqgYlRir0DbSk0DInxilp/jRjP/SIN4Tzl1sCM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:d135495111850ea36086dea4d03c7afd828d7829ebdef9d7cbc36a7090e8e056";
  hash = "sha256-/cYGCoZngJNpqljIGK5dHUwNSH0d5+zqZA1xrIB0goY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

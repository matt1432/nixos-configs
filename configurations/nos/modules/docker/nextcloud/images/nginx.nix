pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:6a3df739b6312289e87d70947d900669c1b3087474ece5814b9c01bbf2e6dde3";
  hash = "sha256-4yOavsAM/J42mMF3G1TPitO7ulxUg5BQDHNepaLsXAU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

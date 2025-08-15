pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:60c888e18b41da9f91670c7e1ca2296ac3c0094e64b626f89425f178b9361965";
  hash = "sha256-kdDGS4VNbrYgsZpyT7Uv3HN6zDfsUsqmewV6PRFqHZg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

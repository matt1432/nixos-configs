pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:05b758a554de5c1b391f5247850bb74cab7229ec28caa1b46629ca8e53940fb1";
  hash = "sha256-5XGRvFUjF4L3ZOZvPzHA3ftkQrrSWS5HRVqBCiqOXk8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

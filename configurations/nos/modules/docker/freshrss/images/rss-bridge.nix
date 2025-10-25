pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:2c88bdb056dfb5c5ee9f95f005a71206d2881e8113fff51fcf8e2a775858087a";
  hash = "sha256-/HJTJazwLdYnNUZPN6zE830T2pAW0P3MVwXnJaPcgWA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

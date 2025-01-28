pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:ee6fef3aa2d8699a4379acbaf01da5efeac1a8581a2d02de9b78786b680be8ba";
  hash = "sha256-YuRqOey6yjr2W+klTIDuQ1BrdbwnXiCrusqzC31aTuE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

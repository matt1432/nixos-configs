pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:eea4469cd57e660e3bea8f29a51aeb66f05badb47b85d8b539a1011df2fde49a";
  hash = "sha256-foZJtjvhEwxsvYMaEniS4OUA6ou9led9x4z8j4yvk88=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

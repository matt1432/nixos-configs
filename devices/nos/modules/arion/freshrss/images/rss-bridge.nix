pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:5fca58c11283324744aacd4dc07b1f4e8751a92f23768d8eed1fdf471065409e";
  sha256 = "0w9pf6ahsld6siq5p8cfx6wbjr64h2vahp8s52an4lvmczxmq13p";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}

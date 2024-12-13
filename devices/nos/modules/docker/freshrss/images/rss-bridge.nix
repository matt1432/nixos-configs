pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:57b56306461cf71bcfc8c46632cc2105367a54a03eae6c403dd0a59de8fb6598";
  hash = "sha256-YRpc9k4LP9lsrXx4+DLqsL5K7LHNMXk/NSWcUK3GVSI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

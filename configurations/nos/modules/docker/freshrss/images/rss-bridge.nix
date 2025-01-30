pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:d6957a957ecf26362298455834c3efbfaa9857c011122aea2e843bdd72d9b92c";
  hash = "sha256-fAAJI3VwxVcAgONaccImyU6GKdvpHy8fR5Dd/xFwXvc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

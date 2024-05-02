pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:fd198aab959659481fc750d7f8b1467230cf689c573949a1ae328715e7d2e7db";
  sha256 = "0jh0qy6r01xqw7dyqyqhby62m1qz0w679gmvbp6a22cn3akdhjyn";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}

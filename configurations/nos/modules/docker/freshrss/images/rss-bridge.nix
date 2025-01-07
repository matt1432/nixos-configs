pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:dc9aecdbbc73f2e78628a04d4e6973f8947b38f648a7d97927b80c6da340f22f";
  hash = "sha256-ZUznzJjc9z9LObMdLxzTrH5XaKJjrtX+fEKY7PffpFQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

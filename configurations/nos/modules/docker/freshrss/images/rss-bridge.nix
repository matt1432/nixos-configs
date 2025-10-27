pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:b916493e9e4f1ffa65c85d904a4f4be73b9ebb81af297acd39d58a032e80f6d8";
  hash = "sha256-0IJCJf1uRKWPoIzJ0LURuqUcYPyr7dGIQKJZWt3Fgkc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:f8b3bc834ff02eeacfd0fed1fc2227b94a6d70568c22b75362b36bbb045c6d45";
  hash = "sha256-U5qR2hXnrB8SnKnLbyYoWBXNTi/2zS7g+0JieQPiilk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

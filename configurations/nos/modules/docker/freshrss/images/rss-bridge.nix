pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:222e1ad7f207a58bfb49c69925b233405d2eff8a7a61cd5ab094631de02765f8";
  hash = "sha256-aSFA3DKfk4qViBJUsk9IfUfZwKmIQKon7rdC8gT1H9o=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

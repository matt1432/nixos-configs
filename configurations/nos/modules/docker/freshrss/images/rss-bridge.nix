pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:51c31a98c02be55bc7f1f1cc616c32189ffe93a010a765f8ff8c9ea40c8f55eb";
  hash = "sha256-VVseKbNxy+I0ED4H67pGuP38TAZTRoyGwDWkVrm6fhg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

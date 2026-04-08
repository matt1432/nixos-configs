pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:f31cf3118ab2c167fc76c069e1e53d7a64d87684cdbf891b0dd3c547029fc6f0";
  hash = "sha256-g/DteEtHb1ux21QM3cTIKn2rciImbjD9zyv9BqKeFs4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:63a4bb71b43762957a089d9ab459dc5d530c2f2c71fb67ffbde9ec5c3cc64de7";
  hash = "sha256-gTl9Ldg1EMemPbPaT4jUYBuV9FK1f4iL++baMn++QcU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

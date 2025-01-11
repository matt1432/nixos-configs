pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:2f94bc58b926a9ae2efb62c2bd08723b22adceb47d5590be00b56dc05ba2a0e3";
  hash = "sha256-h1vq77Z+zH1eYb8HfEaOFP/DmzlNgZfnEkoKjITug4Y=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

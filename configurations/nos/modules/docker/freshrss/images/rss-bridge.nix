pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:bbf0b35787674721498a3c53408ff5ba364de4c341319bfee701e55320492e33";
  hash = "sha256-p1qiE7j4KvaLROEwuPoxE8XgCB6Q2Zsgav3zTruTsko=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

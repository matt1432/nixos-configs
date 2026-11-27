pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:a543223e151d0a3eb0ffbcadd58e5352f9cfe706e1cc3c5e198786a674e4673f";
  hash = "sha256-BjOPaESfWiwaEdGr3PneTnPPED3KvN8lCIQdhynVfO8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

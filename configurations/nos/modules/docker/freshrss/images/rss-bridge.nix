pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:a56756ea83ab7f38c694982369f972afb6bf3ae87571792687411e34c230d165";
  hash = "sha256-jqVcCiR43agz3ntniIuOanI5nkRezrxtQh/t3Z4cGl8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

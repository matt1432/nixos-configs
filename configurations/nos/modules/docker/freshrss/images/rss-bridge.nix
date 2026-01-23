pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:2cb51143d5246f08d40160cc22d37b8415100299ccf1afdeaa6cf3b420a61780";
  hash = "sha256-KWGmMenN4gVDjmk/W8n6X37gdoxLCiDUBiyf2cmc48o=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

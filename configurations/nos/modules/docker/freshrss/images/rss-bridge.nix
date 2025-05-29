pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:b225b64c7f5d94f9210beb19f7fa35ca34120677560c4576174ed460aebe0d81";
  hash = "sha256-GgXm/tdDIfpu88RUX03GwVSDtFzIcUxmdRudSts2beo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

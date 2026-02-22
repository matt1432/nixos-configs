pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:92b38282d68ff9ff370b24215d477a2ce2a30eb162ae1b3a96d347fd05388af8";
  hash = "sha256-muE0Gg+1+U2e2XL/hPWG1ep090ErcUZ2ZzIl49foOMg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

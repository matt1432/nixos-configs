pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:6119dc379611934ff7a959b37c21ba65e9428ab801c2d0faaf9a61834895866b";
  hash = "sha256-PH4NK4bxYG3ln53FE2N1Z132gFQ99dPTWTCRYpKrPWI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

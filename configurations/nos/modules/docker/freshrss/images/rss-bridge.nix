pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:217ff9ee7a3c44dea6c4b17e36f1e0f4c6028440ab63dadf7be80683cddd8b38";
  hash = "sha256-sBD2mKXSeLPfBPc7SFawEZrQYqJHj8uECCx7/Izg+5o=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

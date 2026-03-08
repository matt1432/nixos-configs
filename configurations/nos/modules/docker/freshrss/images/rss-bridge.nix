pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:2b4b9e0a47e0d69c2cc8ad14e64e49432529894ad7b65cb23c4c3205cbf52eb7";
  hash = "sha256-6WzR1wFPB26HCNZ+fu8y2j7Sj4IcTKq06nGMuoVGM2U=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

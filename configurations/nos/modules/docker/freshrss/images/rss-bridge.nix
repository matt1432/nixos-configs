pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:49fb446500f9b3d731e02449ec5229601afcdd304a224d7dcd6fe2208d1c3f81";
  hash = "sha256-+yzUD1JYCldhkRDFTOFgR/PJ7CLT8veBgaKtZOtocAU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

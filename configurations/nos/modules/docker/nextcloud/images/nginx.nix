pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:42f2d24ae18df9b5251d1cc45548085656d2335e9338fd150a24e415462d151f";
  hash = "sha256-HdNmcL4GALeoxnPCG/5QAIZP2xLBOL8Vyhq5JobbxtI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

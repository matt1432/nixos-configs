pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:3673ad2455a4dfbdbeef2860aa0f5955b3b122a5ed56d463a0315df9e4405758";
  sha256 = "0im67rbxlkpa2zgr0d3ql6yg9jhj5xjw8f0gk397wixh0761psab";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.4-fpm";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:bbcaba1d74865ee6d6318b5e297d0df73d1f6b6d995cd892b60a2cf1440b716a";
  hash = "sha256-DwLLgvKHCX571uTxgCDrUG9cpyVX/tcKHKBBHNa0Tl8=";
  finalImageName = imageName;
  finalImageTag = "14";
}

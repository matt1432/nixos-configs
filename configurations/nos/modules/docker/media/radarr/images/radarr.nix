pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:dd31e90d63f2e4a941893aaa7648dfb42fd12ccd242823fc4e22d1904bc0eca9";
  hash = "sha256-BoVmux1R1c6qN1/5nmogvtTEt64ocr+tIas/xS2iqS8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

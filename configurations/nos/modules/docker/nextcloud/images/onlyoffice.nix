pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:68ef4bee1827ca4cd3dace67e127f4e796fa91303900007cd8dd97151b0e623c";
  hash = "sha256-Qlf37RkTjJv1wrekL8Brjy1j9sDtruSYgRsavmtBs+E=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:5baf571c177eda579fbaa080ade2135bce9097bc3c165f92d30e399df64d0bc4";
  sha256 = "1sgdlrkm3wmcbncv4488365vjhfg00vn4jghnrpd402cypvkrqch";
  finalImageName = imageName;
  finalImageTag = "latest";
}

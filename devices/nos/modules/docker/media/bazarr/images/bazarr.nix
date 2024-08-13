pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:0ac10a3e9ef16ee17bfd0719bcadc18b30572b54dbe76d6bd865a160eefb22b7";
  sha256 = "17w8kjwrzp05k7fvsf8jj3vqh42zbbn0xj15qm3avav5cdz08q0i";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}

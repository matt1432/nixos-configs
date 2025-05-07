pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:034e679ae691e10841a0a5a54cd349b042f49f5403cd66211c001314056f567f";
  hash = "sha256-yYYQ5+up81kOo6hT+9EWafaCnVOwWk/Yp8QVBESsxD0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:ca43905eaf2dd11425efdcfe184892e43806b1ae0a830440c825cecbc2629cfb";
  hash = "sha256-HkR+p/EW+jnr9+Kq/RvZONmpQR2syDKaff/geC92ydY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

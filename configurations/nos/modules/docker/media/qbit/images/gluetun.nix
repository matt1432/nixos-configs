pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:5ec05d70f344ebc70208ad044046e0ea677741e3afcba5ad0ec5b00a3c63a467";
  hash = "sha256-9cRVUMFSi7jkb/Qk7BvdSUcBgC0SYPdO6Q0WWb19qxI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

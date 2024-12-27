pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:447b8d85c4b1290d42b526e4cdd70af380e69bb2f70c4d2497816d7a528d2a08";
  hash = "sha256-y1i3szizi8hfD2nR/xbCdMyZbdouDUcOtdetJMb6Y6k=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

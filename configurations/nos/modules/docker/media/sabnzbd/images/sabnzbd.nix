pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:7afe3af1cff19c2a7a5d4bacb2202fcb21a0ee15b7e23e4114ab3f7070213662";
  hash = "sha256-A2y29l8YW662tTEW2lt3srcEoYuLjLrfWd4Jy4+2bEY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/gethomepage/homepage";
  imageDigest = "sha256:d41dca72f3a68d2c675eb232a448104af200096f05e2610ffbfdb16bc7f71410";
  sha256 = "0x97p3d22qb43p653qrf29aknxwla1nnss3sk32wn6gapg1v05iy";
  finalImageName = imageName;
  finalImageTag = "latest";
}

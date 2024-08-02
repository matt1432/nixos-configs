pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:dda700370ad4281d8ffda4fbdad8ac3f720a2829936eafc794fca652095ed4be";
  sha256 = "1cgjkja9zl8s76g0x258gism7ah1p2ni72nlx0jp0skdpm7y1irx";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}

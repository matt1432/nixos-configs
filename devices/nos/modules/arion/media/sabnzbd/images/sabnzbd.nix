pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:a6cee28d0fde04987037b1d29173f651051d6e7dbe75209cac28625b1fe19251";
  sha256 = "01pin2q2kykn31yxhmm01ph2l5kpryr1vc78ra1fchb5pzgdzxan";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}

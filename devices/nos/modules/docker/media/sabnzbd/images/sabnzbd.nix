pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:374a89d565afda9e90ffb01b1ed032390cf701f24e9c035a842440194fdca1a0";
  sha256 = "0fzijfajf5lgy343jzw0gdmzxjf51rfwrm58qf48bj6xgdczy5w1";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:134199776cc6e750896c40a2eae547713ecd8c1bc7912369046b19382283c176";
  sha256 = "0d5d39a5l9kb5gm24xwjxsqxiayk052lx7j04argllbb4b18bi5k";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:1fc3067c4e684a4139be2e17915a63e9355ccba91c954a330d33fcb033bf7e71";
  hash = "sha256-Ibw+8VS1hnA5vjFf2rlyqAJL9s1+L5UmiSBqwLVK6Ek=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

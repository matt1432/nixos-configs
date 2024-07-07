pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:db76abdcd65ba2c06a630d17d7e71e75245f8c7ace734d4cadd6402e2776ad5c";
  sha256 = "0m8d8xiyip99wvlq83n06drn8fyl3kq6lf1dwi5zb64jjqs16d6x";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}

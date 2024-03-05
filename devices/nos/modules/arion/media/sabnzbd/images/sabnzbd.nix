pkgs:
pkgs.dockerTools.pullImage {
  imageName = "lscr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:0048320fe830e5c6a06167ac57625b7777f7d1dff18c404181bd2bc2e6914e8f";
  sha256 = "0x8fk41ppnc9fhnm9zrfbjmqzlx7falz8a9awc8ys1ipi1hnmxa2";
  finalImageName = "lscr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}

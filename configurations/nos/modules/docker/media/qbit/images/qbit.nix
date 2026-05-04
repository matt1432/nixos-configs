pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:c9990949e968e99333f47f49da7d16e81ba6e1469c8c46807a65b984c9e8b6ff";
  hash = "sha256-30Q0VcZ3UodmjWVNSFkymyMIo8gEZ/yP7Hxw3nyKMiY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

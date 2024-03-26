pkgs:
pkgs.dockerTools.pullImage {
  imageName = "lscr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:7f707fa297fa0151857d5899dbbda02130da7c85b26454f563caf1a3f7eccff2";
  sha256 = "1z0ja65861vlra9g83kfnl8css8gb1qsnp1yjg39l0qkymxf2j59";
  finalImageName = "lscr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}

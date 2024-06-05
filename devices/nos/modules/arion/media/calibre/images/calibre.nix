pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:b82bfa1803a4191b7c4eac545dd82e6b9ca15ab006f979223a93eff1ff00fdba";
  sha256 = "0x0pdkpb5qy1gkyzlax0v9lxvhkvmqganim83xyyjxmc7hs1rbgl";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}

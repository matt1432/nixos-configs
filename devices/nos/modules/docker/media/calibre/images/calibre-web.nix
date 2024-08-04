pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:14c3eafe5aec2344581e27991adc6545c9928f54020b50affe1678b8b5f22021";
  sha256 = "16ai2zl1cvacjn10n06msqwrf9nqr1a024ra6868z1mzjkbyr85p";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}

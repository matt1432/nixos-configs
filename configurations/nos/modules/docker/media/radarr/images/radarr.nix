pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:01233b9ea9435fd00eab51891f133d86c9b6293f5adb8c3bf44e7a314c9c3423";
  hash = "sha256-Yb/msZXA8dB/sHtpXxha3pGnMXZ9QDnb6VVYuR1bTBk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:f76c4363cce0834df43b097682928d217f9f0e0fa1d13781c0934848d543e4ab";
  hash = "sha256-bQySJ/QoadmMwhWx43ySN6lmTV0FIwzZRZ6/sPgthUw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

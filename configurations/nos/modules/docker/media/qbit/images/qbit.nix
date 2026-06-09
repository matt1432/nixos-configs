pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:689c81f580345135e48b5aa09b26a4d864d7af1b9a496a47db61eebe71fd480c";
  hash = "sha256-msPDbNpulf4yn7blfYZrWeD5Ts29exjLIUWlftDbpEg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:caf49e3b10d377aa2cfee478591d623808527beb27125d38797b418013f72d81";
  hash = "sha256-4nxqUA5xtOQXCtsiUtOIE06cyLC6hZwSxxbqDvp2Yhs=";
  finalImageName = imageName;
  finalImageTag = "14";
}

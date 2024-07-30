pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:49660a8890e2e4356cbc4b8874ff5ad1ebc40f647fdb2419fc289700affebcf0";
  sha256 = "10pmvjd32jsr8xw2bn008ydhnxpbfg4d1zx3s42w84q215m8c7n4";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}

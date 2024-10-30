pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:dc2267f989b8c8f5b9152b11bbd353d4f1a097619c551558b01b8638554e9f5a";
  sha256 = "188bpkf5bq3sr9k84335z4cdr8hdcps5dvlhhm2gxqzv96wg0dwk";
  finalImageName = imageName;
  finalImageTag = "9";
}

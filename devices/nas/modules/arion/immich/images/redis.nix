# Locked
pkgs:
pkgs.dockerTools.pullImage {
  imageName = "redis";
  imageDigest = "sha256:70a7a5b641117670beae0d80658430853896b5ef269ccf00d1827427e3263fa3";
  sha256 = "1d14llwfzjfpzyz7x1a46fzrrg3i6k7z89jqql3sfisb7i4kgp2j";
  finalImageName = "redis";
  finalImageTag = "6.2-alpine";
}

pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:1a130f6555c0a0afe0513560f0d525238709d553fab688bc0579ecae65a664ca";
  sha256 = "0fl8zfw2a1h7k70p7vn1yx6fhi5l7qkqssjjqq90r8y22wv0qd3g";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}

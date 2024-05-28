pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:fab0fda498a1354fad88ece34119f35118faf292678e0b2c18956dfa690cd2ab";
  sha256 = "0dn99lqyafq4va3acb9cqf8j93z5lgzbbcs298v5hm4lqgi8s6mm";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}

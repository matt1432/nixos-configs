pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:ab3c6fb537e1b3085963c7407a4971e7e535812341eb65b10b42691389697292";
  sha256 = "0x35v68bjwjkfnrjqvisg4gv7dwaz5qsb9y3xl2rdrbjbm30yvg4";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}

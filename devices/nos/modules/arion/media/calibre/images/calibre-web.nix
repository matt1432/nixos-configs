pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:96a7940ff83386017ab42942220312e2c1ddc88245f320d3696f2683e58ebb0e";
  sha256 = "0nzy0y6s8s8jcfidni8b49464jayfn9k781ipbzspk6xcrnibksf";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}

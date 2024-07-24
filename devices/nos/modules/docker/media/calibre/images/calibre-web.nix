pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:604ae903f520bd5485bcbdb2f70ea460c90a559bca3d4ac3fc05b93da2737a0a";
  sha256 = "0vzhb4q64vlz5q92lc406vpd2bzzyg7d8h251h8fvgdprycka619";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}

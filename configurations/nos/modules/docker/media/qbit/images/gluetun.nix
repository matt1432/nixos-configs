pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:725d3e51091dde4ca43e3e3f26e2e6d3d0ccc66821e92d505c3da04958f7d472";
  hash = "sha256-mqUqYfNH4Cnk59RTBR/qOr+Xu1/UEcJiwtl+UHa+/Uo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

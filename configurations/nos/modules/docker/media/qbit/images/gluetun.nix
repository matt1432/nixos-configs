pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:d404457464306995a362e5f96c054712df01f7932d2df2a454f72817ca3ecef4";
  hash = "sha256-24eMQuUvBo74c8CDiUGQR9wh8hOcCHTolOo3Wo08mtU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

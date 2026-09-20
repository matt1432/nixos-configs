pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:12df8b20528d4cd5e9b6e827d40f2886cf78e53e7e9afc750050648c31183793";
  hash = "sha256-IdAYyxrxpPaPXiUdcEZbCGN4lc8k6iYDc/UUXdQ7uW0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

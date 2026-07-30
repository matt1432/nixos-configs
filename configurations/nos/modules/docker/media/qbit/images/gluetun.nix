pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:e67bd4c664b103a6112a20e44384ce1cbe9394c41eb4de918693035699509956";
  hash = "sha256-JC9JIb9qoe2nxFicPIWrZkH09BusGbF/vXhU5z8JH9Y=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

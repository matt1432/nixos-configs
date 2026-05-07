pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:0d60fc67b2847ffb9b3ec2b42a4f5523c38e0e464974e71a640e8dcf0a52a0ee";
  hash = "sha256-Nuza2jjzoP6MiiiVkYeJjalVLv9USsHwDKG0aoTkraM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:6d21823e204e99adbb0aa811105504514d16150cc5299f443f191c28792fcf4b";
  hash = "sha256-4/ZSrZ4ZXR87i0FNBuqYp2/23oR6YktwMz+YLY2MStg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

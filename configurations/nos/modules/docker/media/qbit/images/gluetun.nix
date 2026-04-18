pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:085e738d23268dd51d5876b3e59412f47fd37fda6d8e4050e8c7502bb679de47";
  hash = "sha256-m8Q8pbV1eJJojaCOiIwmQZ0cZqTOnJBItqoTJNDS8Qc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

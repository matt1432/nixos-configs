pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:62810455bc9dacdcf887ddeb33b0e054d39a048ebe9264dff2f2692ce180a35c";
  hash = "sha256-sPoPQiBlibpcOZfXX0NvUWgFHC2JQqW9TmQInWZTbYw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

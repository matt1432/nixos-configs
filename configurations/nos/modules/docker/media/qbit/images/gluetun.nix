pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:c21e16d538184d16ef7a41509bd399653cc7f34cb87bd6c1c4b685cff8b49525";
  hash = "sha256-53fs343XKWHV+adQKPvpdlJWmifH6Xo9gMCYbTfW01Y=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

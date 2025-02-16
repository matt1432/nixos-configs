pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "netdaemon/netdaemon5";
  imageDigest = "sha256:4d655d76f2eabe8958d297a6d04a7f78b3e4165dfa800a0e45b5bca78fe770f2";
  hash = "sha256-DZodCQHzAcHX7BGXGlQ4VZg3AOv7mlSyC3hwT1zavHo=";
  finalImageName = imageName;
  finalImageTag = "25.6.0";
}

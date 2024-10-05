pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "netdaemon/netdaemon4";
  imageDigest = "sha256:2ccb8dce2a7a5bba14bd90030640f09a91adccb472e16168ad06ae1f752430ae";
  sha256 = "1qj2yrbhcr162ikfv3jbh4qvb17p7vzxva5z3r5vhhimayr24dn4";
  finalImageName = imageName;
  finalImageTag = "24.37.1";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:e3272b29a4bc177b389fbdcb54cf9716ccbfc30f04d8b7a35b0a5be9cdb58461";
  hash = "sha256-wOWFAYpPgRfgiAQSAsjfghnRbcu21brhoVsIIDz3/qA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

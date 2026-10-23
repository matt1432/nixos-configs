pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:8ab94f61668dc73bbab4dc13273ff2fc37e635536af62aef5306a49a9682a446";
  hash = "sha256-97NHT4h3LaWf8T0lK8Z7b9djX2Y3V+/nEthSzjKSFBs=";
  finalImageName = imageName;
  finalImageTag = "14";
}

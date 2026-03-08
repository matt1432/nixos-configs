pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:53a06109f1f4029a78f913a061e14f01bff023d109024073a13d4416b54d2195";
  hash = "sha256-l47wdmVr/cPiXH8sESAMPJRaBgQblUuq3U2ldgKMULY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

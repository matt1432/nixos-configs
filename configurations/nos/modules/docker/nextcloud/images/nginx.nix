pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:6e23479198b998e5e25921dff8455837c7636a67111a04a635cf1bb363d199dc";
  hash = "sha256-zbpbbk9EYRLIncuBzOObPHtTro2tlKVOvxDNxHnxdww=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

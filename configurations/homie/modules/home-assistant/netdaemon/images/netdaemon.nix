pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "netdaemon/netdaemon5";
  imageDigest = "sha256:b64b6ee37a3ba7a9f70b368d255774a5df594ec66a107d3de2b0c68423f73150";
  hash = "sha256-xPcM70xBKSTPdIaW4MGNWi81yuBzR4Zg9azSHUMNm/Y=";
  finalImageName = imageName;
  finalImageTag = "25.14.1";
}

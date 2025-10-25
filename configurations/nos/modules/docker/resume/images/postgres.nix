pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:029660641a0cfc575b14f336ba448fb8a75fd595d42e1fa316b9fb4378742297";
  hash = "sha256-90cIOMoopws/z+69VUOE05Jfpn+A3xu3sA91OOW7PPM=";
  finalImageName = imageName;
  finalImageTag = "16-alpine";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:03379eed4ab21d32530f0a832017f06f79313f86276eab0b762c7c7e1eb998ff";
  hash = "sha256-90cIOMoopws/z+69VUOE05Jfpn+A3xu3sA91OOW7PPM=";
  finalImageName = imageName;
  finalImageTag = "16-alpine";
}

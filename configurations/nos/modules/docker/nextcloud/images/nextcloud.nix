pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:f6b2ec624555c8f63b0b5f8950b432e10352f522b571b66283f10d20b7ef62aa";
  hash = "sha256-L9I1mm6S7XAYP443H6+aaU8pXE2FFZ8K3xTUcDbulOg=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:6cf2c2727696954fb25f3f6061f195a6b1a366e1e7c66a3d53fb004322544d21";
  hash = "sha256-ECpF0n9cyEH5GdHZYjwePcmb2ge96t4CB5C3OWwwu1s=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

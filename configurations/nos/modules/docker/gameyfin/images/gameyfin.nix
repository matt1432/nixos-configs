pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "grimsi/gameyfin";
  imageDigest = "sha256:c726da53c782dfd792d9a67eec7c42295d057e8468f59d5ce33dc5d7fb522ed0";
  hash = "sha256-PJyveWbwTSBkZGwfvtDT1I/FCmz0GDsLbxaCpDE200w=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

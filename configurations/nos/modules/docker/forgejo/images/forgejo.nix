pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:fe7a6d15d0ee210042550feb5e35c44fc3c718621648d80d07aa8498ce243448";
  hash = "sha256-EBUHsEI5mGWAmsdP0Kg+polriPJjpa3kcn6twmwxTv0=";
  finalImageName = imageName;
  finalImageTag = "13";
}

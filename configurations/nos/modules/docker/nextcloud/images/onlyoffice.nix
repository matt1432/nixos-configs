pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:fd00acbbbde3d8b1ead9b933aafa7c2df77e62c48b1b171886e6bef343c13882";
  hash = "sha256-3gOCR6brSvU0mVVI0rcNEXdK+vZu0TT3iqBoqFIpNbI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

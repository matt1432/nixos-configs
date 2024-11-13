pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:4af9878e3c663739f313ab60ad43f810a3c21d3726652efcd11917b95da1e4f7";
  sha256 = "10j7m81f10jzbas10h63ify74b62yf69qyn83xcncbgnjh0h207z";
  finalImageName = imageName;
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/matt1432/airdcpp-gluetun-sync";
  imageDigest = "sha256:81cf77c5226bbd15e0bcd8d2af4958cb10a0a289cd07f37b2381a91742d58f84";
  hash = "sha256-oBsAZAFWSdpLv/2vBcu5BDVE5R+iBPDuXacE2ewYg48=";
  finalImageName = imageName;
  finalImageTag = "main";
}

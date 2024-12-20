pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:3a4135cc058422f80ae503468e4af4cdc5df41331ab01988f9372a6861d916ca";
  hash = "sha256-M/X/Y7oj8c/3BtbJwymIrpuc4aXTX2cC3Jo7ILM40Dw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

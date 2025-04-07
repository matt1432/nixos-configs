pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "cyfershepard/jellystat";
  imageDigest = "sha256:655642855f67cf810a76802afc13987ed88571a9ce865ad28ba7a09ad9bb568f";
  hash = "sha256-TaPJDNtSzwMpompRLr5oP2zk5yUbJS1f2Vxlbwlfv00=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

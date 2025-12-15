pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:6c0948b42c149e36bb3dbc0b64d36c77b2d3c9dccf1b424c4f72af1e57ba0c21";
  hash = "sha256-bho7i7cdDRDB1YEvBcaazSxFFa23hw2k96kaq4IXrwk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

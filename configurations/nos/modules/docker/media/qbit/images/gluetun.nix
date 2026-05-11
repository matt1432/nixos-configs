pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:18a0abe7a020acdf9f80db45440d18487239abde5495a357ceb36517f7ea67cf";
  hash = "sha256-7caZV3tjQCRHsxtF/X19kfTPx4+uakiY/WVC3QdDZBk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:f547e3d0d5d02f7009737b284abc87d808e4252b42dceea361811e9fc606287f";
  hash = "sha256-vVXdNXPVPxmuxBKo8ydZBmQ2kPP6zzogPtkhT8vN4go=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

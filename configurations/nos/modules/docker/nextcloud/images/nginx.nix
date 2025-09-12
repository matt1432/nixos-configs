pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:d5f28ef21aabddd098f3dbc21fe5b7a7d7a184720bc07da0b6c9b9820e97f25e";
  hash = "sha256-IFjvnWmy0hsFBr55BFOqkIw3G84c06o0UAn7ifjVghY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

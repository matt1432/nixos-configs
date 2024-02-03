pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:75292ac707d3a43795a21a7a728e95e315ef9d4082918816ba0c979c9bfb5aef";
  sha256 = "0s4hh6asc7r7qa0dbgzx9dqfhrap6xap17a0hyjfhhazq270flsl";
  finalImageName = "postgres";
  finalImageTag = "14";
}

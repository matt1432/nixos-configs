pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:95c46edf71cef1b18500fce60313b4d7f7652ea7d78ba71033155efc25f16093";
  hash = "sha256-LCiw9tKYj5CnaZk6eq/RXrvr13/tYFvsxqEYV13BvgE=";
  finalImageName = imageName;
  finalImageTag = "10";
}

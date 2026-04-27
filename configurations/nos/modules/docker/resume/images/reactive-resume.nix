pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:1971fcff35612a7c975fee768ef07588959e86ad514f8bcac8d7832a20a56e00";
  hash = "sha256-zywsI3RQSDDjSKv5WZ5wOT15OeDE6RGjDZxA/mWh5H8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

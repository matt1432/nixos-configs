pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:82e1b4163313ccf4f6b7479e82ccfb81fc13af19eca9f806e85b07773ef61201";
  hash = "sha256-NDC4nsNx3YgVnZVUc3ydj/pznNR/zKo6eL7q7EXlckg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:ad68e89b675740867a3bb96488a93fea9209ad36c6305bfba2664912d6dcf11a";
  hash = "sha256-qLJepoZRMhS4To6M9clEzgfFoY4Pw0W/DyltPP9pNF8=";
  finalImageName = imageName;
  finalImageTag = "dind";
}

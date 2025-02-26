pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:fdd813b61602839c0a742e43425d484e44f24d3ab621a81921ed8991ee2e2eaa";
  hash = "sha256-T/jqi6FQPqdmg5+0jh5ISlTyunCNhF/GF8pagn9NGvM=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}

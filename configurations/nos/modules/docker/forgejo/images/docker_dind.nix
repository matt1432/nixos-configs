pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:7bb861a04bb42bda1d237fc2cb539f9823c9b666ecfbfdbd3e534ab74c8cb976";
  hash = "sha256-6fvCUwgiNW8te2MtiBYceG+ukzfMfzmT83k8951knsU=";
  finalImageName = imageName;
  finalImageTag = "dind";
}

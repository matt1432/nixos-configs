pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/jlesage/jdownloader-2";
  imageDigest = "sha256:d9c73baf04f10a035974178aeafba3ef23aa600e2393a7b30920ea1e2b6401cf";
  hash = "sha256-9m+9uP+FWbn96X5KkUr0sG9bBuMHu0/Of2RbG945dWs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

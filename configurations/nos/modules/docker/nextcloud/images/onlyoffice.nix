pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:e0a74be8c96fa91a9f55855e86ffb6d4d247d4c8d19dfaef7f441890a1bdbfd3";
  hash = "sha256-vqZXv/7Im3KuQQ9B9k8iQ1La1qSQxjYVrcsY8XgFzwo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

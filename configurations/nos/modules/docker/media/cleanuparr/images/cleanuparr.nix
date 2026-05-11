pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/cleanuparr/cleanuparr";
  imageDigest = "sha256:9b8f7a5f740c6cdc8f799a1d4b367ea560c0ce60799100afc3e14b6e3468cb5e";
  hash = "sha256-rByCnTHP17b0rqDFxmmFg0X3zM+kc1b7kOQ43DwTMEk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

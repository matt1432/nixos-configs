pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:659e5f20500948b1491f31dd85c6f99a43508ce3e46595793e1e15aa955bf6d7";
  hash = "sha256-1ZcECMTn+jSjflUEA5CuS9uNI5jsC0mvLnF/qBebT8k=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

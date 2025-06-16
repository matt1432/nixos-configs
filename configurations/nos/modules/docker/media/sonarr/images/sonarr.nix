pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:de67e5b682fedcc4ac34f28a5697931c680c959ea65f8111b0cce17bc698c0b2";
  hash = "sha256-SgEcdG9tqljlgvTf7lW17P3B4sz9k8cBkQxBLfl8AUQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

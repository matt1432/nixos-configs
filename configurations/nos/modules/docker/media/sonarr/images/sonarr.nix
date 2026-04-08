pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:b5670a3adb0f8a8b0f277feeaa69a5fbe3869ba4bb9fa7c0f0764c3b3f0e698f";
  hash = "sha256-4tVmdgb96cmOCIyjxE4aFyLG+AsPLvzsBbX5blWC05I=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

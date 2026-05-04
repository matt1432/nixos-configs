pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:d626d04934cd1192ad8ced1adb975099fca78cec33ab467d2d3c923cde7f3b0c";
  hash = "sha256-mbBYD3JMFAB2Lv4E8czCEpsgKsLMKM47qTi+ctTqZu8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

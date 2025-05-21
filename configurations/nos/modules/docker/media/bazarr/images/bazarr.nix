pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:2458b13b6bdb9beee13acd2c70172140e9f9362488914d9f7cd95a473c3742b7";
  hash = "sha256-3V+dbu9ZwULp+jHKxnJxyA8ZdFTZZYktoSlbVZbmWFQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

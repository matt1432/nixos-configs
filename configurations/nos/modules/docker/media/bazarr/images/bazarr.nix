pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:8b30e81c4aec2991f469e78fae8afaa89ecc9b21a80e3897f50427216b55470c";
  hash = "sha256-fwvGtEruJ5Nuu3DGM9sewkTxZ9GCWkuV8kypkHCzqpM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

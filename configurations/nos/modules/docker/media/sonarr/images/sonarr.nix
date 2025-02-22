pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:4dfedb2598dc6bd51c40f4ecea2631dbe367840678ab109cd968f821d81a5327";
  hash = "sha256-CufEOW1zKt05SqE4QH76bWqI/UBNupYcmh4nnE/91Wo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

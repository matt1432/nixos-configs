pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:c7d1df25e428da6c9ace05daea0d34e59522978a3843ea1944812f855af4086c";
  hash = "sha256-wol98iDK/nvPzvSkXDx/NlTXESosSIZf2PelzQ9iv5Q=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

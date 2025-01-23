pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:9f68851d8fbb4feb09b0cd8aa840c7f140fb3279edfd957f92d78c60591af39f";
  hash = "sha256-r0fCeV68VDp6RnC0SeQ+RFMwGAaRaUAzJzeAN56zfFM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

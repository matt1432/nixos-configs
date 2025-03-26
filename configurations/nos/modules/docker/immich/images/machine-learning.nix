pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:695d0b0b083b1f3ff7a91693f573ac4f8919ce15c923bcd04101b817db8e1b03";
  hash = "sha256-Z79vDo7DUiOepZTL297cJSiO2MkimX8wD2I0ZP0KqaU=";
  finalImageName = imageName;
  finalImageTag = "release";
}

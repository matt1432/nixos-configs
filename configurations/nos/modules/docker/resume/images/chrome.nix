pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/browserless/chromium";
  imageDigest = "sha256:70616ef63d19bb0ca011ed99df562958495e17374f08f31a4851badcb4045806";
  hash = "sha256-eVdJElFJqwx124221fDvgp4SbNHrAMzf7QTgMpoRGj4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

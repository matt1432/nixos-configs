pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:5665416a97ad2823dda6986a581b8913cc3af1b196ac768f5130abad4b0d4f62";
  hash = "sha256-6Y+iV9bTSXOX2KHUTwz7hHzrJqMNYg1G5nT70L77XgE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

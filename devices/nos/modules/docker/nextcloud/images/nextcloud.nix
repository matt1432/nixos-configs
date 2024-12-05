pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:8fac67551cdd146e1c5cea72758a5fb9027234636c4ea44efda6748bc1eb6246";
  sha256 = "19fdzmqbd7w406qh0c068wzb6ids4k935lp64knlsjs7y7vq6cyf";
  finalImageName = imageName;
  finalImageTag = "fpm";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/uwudev/ygege";
  imageDigest = "sha256:bdf55f4113ed2207576810f61132d7e4d62cc88018b59c8706dc532e20636579";
  hash = "sha256-H8sgadwD84wKM+cYdx34sw44OO3G6BIRSd5MUZ6tX9M=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

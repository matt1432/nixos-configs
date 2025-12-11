pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:fb01117203ff38c2f9af91db1a7409459182a37c87cced5cb442d1d8fcc66d19";
  hash = "sha256-tbm63xkgzfdUAeSEr7mqq+SUnAfQAXNkNEJEnNSQZxs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

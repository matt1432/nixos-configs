pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:22e82938463a532286bd6b2b902a5a3fa7a5017d46cc6a3cc3b4c6fc365e49f0";
  hash = "sha256-Fn4vZtrFYfWjWnJVyi+Mh0nSsyYGpmZ8yCILUNFactc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

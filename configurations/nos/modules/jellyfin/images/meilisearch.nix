pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:d3127a6732bf283d5a387ecf42afee969c8e4211e2dbbdd680f307969511be2e";
  hash = "sha256-8/TkTLMJ7TqRi+3euIIvjXqF3abSOdrZLIoLKa1MIro=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:c1a52f17c759c2cd6349eede3d5108b8dac07b97e10665b1d64a2d4961c2fd29";
  hash = "sha256-9gNeVQkMs3NuLPXSNK9Kt/e4n8WYockQrgW73bMaAns=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

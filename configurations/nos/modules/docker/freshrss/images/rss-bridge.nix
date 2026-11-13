pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:62e08f813cfa2eca58736e2743dc2018df46b67abb5f5eef48b18f031c948ced";
  hash = "sha256-rwClnNKNgGuYTlwF3UqbJ0kHH51SxRB2WEAeQG7Ap+Y=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

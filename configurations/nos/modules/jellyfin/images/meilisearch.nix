pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:9902342ef8b4fe379cb87052941003a6b9ff18eb603c1dcc96d6c4442b6336df";
  hash = "sha256-Af7LdV7BaPXxmJpivC90QVi8JqXifAhJHlrghex/Sig=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

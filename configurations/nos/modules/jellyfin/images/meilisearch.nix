pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:8d29e977478bb1a1a12f08f4e5a1d83bbe9edb66e66ad5f4c16627c4b9f1e2db";
  hash = "sha256-7/4NAW8ZKOSYhjYBq4kymM+6D2L+cJjZlOx7EAELXcc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

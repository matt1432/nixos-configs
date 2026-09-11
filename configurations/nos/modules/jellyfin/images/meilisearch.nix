pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:c94e58ca09662dd6e65e8f1b0fd145767be3da7d5422a863a27b8d2b68e090c9";
  hash = "sha256-XI7Q2LiIjFcytBAHhZ/hm2eT+9OForUhO5mClCTZe34=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:a9eb29ee09ab4943db3b4c68620bd6f3382e6b2b0ac4431c0e607b48dbcd4c14";
  hash = "sha256-9OjNYSDm1lVJT9Okf8QnmLxpD1vmPb+Fn/L8Dbk9EJM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

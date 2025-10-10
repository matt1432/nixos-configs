pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:14ef9f50add5243fb8dfd13b60df82a76f3c653f0f03b8fee7b5464ab2f0f303";
  hash = "sha256-m+Akc5AoWV1qV3oKN2t/vGqYvvIYjrdLkDPrV1+54TM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

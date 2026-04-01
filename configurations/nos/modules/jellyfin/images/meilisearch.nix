pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:860fa4baed04ae1c235de870edab0c8006227546dea1bbb6411fbfc5e27cf1db";
  hash = "sha256-0Be+l0UUzl6+YiZdvNZ25LFVgebI1u/Zq0MtHFQHw9k=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

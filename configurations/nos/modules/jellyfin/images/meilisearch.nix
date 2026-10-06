pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:e68913ab7d6f5b159529e472cfd362ce3c741fafd3c127961b2142abbe41b3c9";
  hash = "sha256-VHaawRolSbeDpNlO6HL4hQTBtyr3wzpcR3VLuIZebs4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

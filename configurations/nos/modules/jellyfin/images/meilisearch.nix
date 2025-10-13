pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:bac1af7afd5a19b72ec57a660cbb09704926b75ad709ad514ed2f7cf01675256";
  hash = "sha256-XqdvzaPnxRXKBqgg0Va64/nXuTbaxb4g2w7hFMHY6nM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

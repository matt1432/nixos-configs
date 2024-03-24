pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/gethomepage/homepage";
  imageDigest = "sha256:fc0d6e8b469ea8756d7c5bc542eb5c89064b9c47c3fa85f19b70a695c65cb782";
  sha256 = "08alpwh3g7c65blrql5zz87jgzr48nqq2wsv59zdknw2ir3zf6d2";
  finalImageName = "ghcr.io/gethomepage/homepage";
  finalImageTag = "latest";
}

pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:ea112b507c71c32815f1c02782e20a2f5e8dc42d3ea1177b4fed4f25fce4c9d5";
  sha256 = "05xl2gakjxi60y3b4vgzxmrsrxix9hp12pc2yjsrmq2i93dhypsk";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.106.3";
}

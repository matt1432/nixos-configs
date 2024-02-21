pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:78665b75735f248b2ee1646a671d340b6a221260d87c38771c060aef62421a19";
  sha256 = "098yxp2lplrjxf680zkqw36a4j6ha81hgwgira8zb0xfd8caybqg";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.95.1";
}

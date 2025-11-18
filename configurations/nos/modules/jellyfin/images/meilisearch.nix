pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:773759814f59214a0971dc8810ae1d85002e92166d99760cd546d5ee8ac37c14";
  hash = "sha256-DdnCbIVizzh2o2oopS/aPh0wp55SqOHqv7QeHghXUpI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

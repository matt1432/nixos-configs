pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:fa8ce5aba7c20e106c649e00da1f568e8f39c58f1706bcf4f6921f16aaf5ba48";
  hash = "sha256-lzvdqOddTZB/Skw4d4j1Q0lByrBj80YkpfbE86curCk=";
  finalImageName = imageName;
  finalImageTag = "14";
}

pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:a66ac20819e33193c351164fea63fe892fdfdf2fb89ae26b35e67bf14c0f7e2a";
  hash = "sha256-1/eMVPw2LJVJiBkaqVLUi6EkvdiwBvN0E+47RofzkhY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

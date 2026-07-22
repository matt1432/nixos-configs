pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:9694a59df43ee3f54b3fda9c5de381a3ee9852678e3e31cadf37d6bddea7fc1b";
  hash = "sha256-FGTkEmY/It9M9tzKK7+VaLnhlqL4T+BoyS5sNyTvl7U=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

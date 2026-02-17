pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:8b57fc3c7f46535ddef3828df1538465ac19d892eb57c9a10da6df0880bd5856";
  hash = "sha256-fIvwLu5s0ZXjkzGNZhga3/DSmL/yx72AUyKxMhrfzr4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

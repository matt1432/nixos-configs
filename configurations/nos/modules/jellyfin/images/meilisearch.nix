pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:0e3f0f4d442e4fc494dab4c04215d500405a48c85e8720f1d01010b2335446d6";
  hash = "sha256-n7R2EqMg9aTvnwWRvCv7vVDkr6KvvCKGEeOvjHSa/RE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}

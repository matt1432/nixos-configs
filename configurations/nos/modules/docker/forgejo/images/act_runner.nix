pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:e772a18e1300320e0a6168f855e1e2498e2275da55c44d5cd57000b99bbe4f2b";
  hash = "sha256-12Fnai+BP+wIvWVt0wDg1RuoqfXB+COQn/xnAReyz7g=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
